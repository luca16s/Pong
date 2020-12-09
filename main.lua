local ConstanteLove = require 'ConstanteLove'
local Decoder = require 'Decodificador'
local MqttServer = require 'mqttLoveLibrary'
local comprimentoJanela, larguraJanela = love.graphics.getDimensions()
math.randomseed(os.time())

local function defineAngulo()
  local angulo = math.random(55, 90)
  local criterio = math.random(0, 9)

  if criterio%2 == 1 then
    angulo = -angulo
  end
  return angulo
end

local jogo = {
  fonte = love.graphics.newFont(ConstanteLove.nomeFonte, ConstanteLove.tamanhoFonte),
  seno = defineAngulo,
  cosseno = defineAngulo,
  mostrarMensagemInicial = true,
  partidaTerminada = false,
  encerraPartida = true
}

local bola = {
    --imagem = love.graphics.newImage(ConstanteLove.imagemBola),
    raio = ConstanteLove.raioBola,
    posicao = {
        X = (comprimentoJanela / 2) - (ConstanteLove.raioBola / 2),
        Y = (larguraJanela / 2) - (ConstanteLove.raioBola / 2),
    },
    velocidade = {
        X = 10,
        Y = -200,
    },
    audio = love.audio.newSource(ConstanteLove.somBola, 'static'),
}

local posicaoHorizontal = (comprimentoJanela / 2) - (ConstanteLove.comprimentoJogador / 2)

local Player1 = {
  --imagem = love.graphics.newImage(ConstanteLove.imagemJogador),
  x = posicaoHorizontal,
  y = 10,
  largura = ConstanteLove.comprimentoJogador,
  altura = ConstanteLove.alturaJogador,
  placar = 0
}

local Player2 = {
  --imagem = love.graphics.newImage(ConstanteLove.imagemJogador),
  x = posicaoHorizontal,
  y = larguraJanela - 20,
  largura = ConstanteLove.comprimentoJogador,
  altura = ConstanteLove.alturaJogador,
  placar = 0,
  comando = nil
}

local function construirJanela()
    love.window.setFullscreen(false)
    love.window.setTitle(ConstanteLove.TituloJogo)
    love.window.setIcon(love.image.newImageData(ConstanteLove.IconeJogo))
end

local function movimentaBola(velocidade, bola)
    bola.posicao.X = bola.posicao.X + bola.velocidade.X * velocidade
    bola.posicao.Y = bola.posicao.Y + bola.velocidade.Y * velocidade

    if bola.posicao.X < bola.raio then
      bola.velocidade.X = math.abs(bola.velocidade.X)
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.X > comprimentoJanela-bola.raio then
      bola.velocidade.X = -math.abs(bola.velocidade.X)
      bola.audio:stop() bola.audio:play()
    end

    if bola.posicao.Y < bola.raio then
      bola.velocidade.Y = math.abs(bola.velocidade.Y)
      bola.velocidade.X = bola.velocidade.X
      bola.velocidade.Y = bola.velocidade.Y
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.Y > larguraJanela-bola.raio then
      bola.velocidade.Y = -math.abs(bola.velocidade.Y)
      bola.audio:stop() bola.audio:play()
    end

    if bola.posicao.X > Player1.x and Player1.x + Player1.largura > bola.posicao.X and Player1.y + Player1.altura > bola.posicao.Y-20 and 0 > bola.velocidade.Y then
      bola.velocidade.Y = math.abs(bola.velocidade.Y)
      bola.velocidade.X = bola.velocidade.X + 50
      bola.velocidade.Y = bola.velocidade.Y + 50
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.X > Player2.x and Player2.x + Player2.largura > bola.posicao.X and bola.posicao.Y + 20 > Player2.y + Player2.altura and bola.velocidade.Y > 0 then
      bola.velocidade.Y = -math.abs(bola.velocidade.Y)
      bola.velocidade.X = bola.velocidade.X - 50
      bola.velocidade.Y = bola.velocidade.Y - 50
      bola.audio:stop() bola.audio:play()
    elseif Player1.y - Player1.altura/2 > bola.posicao.Y then
      bola.posicao.X = comprimentoJanela/2
      bola.posicao.Y = larguraJanela/2
      Player1.x = posicaoHorizontal
      Player2.x = posicaoHorizontal
      jogo.encerraPartida = true
      Player2.placar = Player2.placar + 1
      MqttServer.sendMessage(ConstanteLove.comandoPontoJogador2, ConstanteLove.canalJogo)
      bola.velocidade.X = 2 * jogo.cosseno()
      bola.velocidade.Y = 2 * jogo.seno()
    elseif bola.posicao.Y > Player2.y + Player2.altura/2 then
      bola.posicao.X = comprimentoJanela/2
      bola.posicao.Y = larguraJanela/2
      Player1.x = posicaoHorizontal
      Player2.x = posicaoHorizontal
      jogo.encerraPartida = true
      Player1.placar = Player1.placar + 1
      MqttServer.sendMessage(ConstanteLove.comandoPontoJogador1, ConstanteLove.canalJogo)
      bola.velocidade.X = 2 * jogo.cosseno()
      bola.velocidade.Y = 2 * jogo.seno()
    end
end

local function movimentaP1(dt)
  if love.keyboard.isDown("right") then
      Player1.x = Player1.x + 300 * dt
      jogo.encerraPartida = false
      jogo.mostrarMensagemInicial = false
    elseif love.keyboard.isDown("left") then
      Player1.x = Player1.x - 300 * dt
      jogo.encerraPartida = false
      jogo.mostrarMensagemInicial = false
    end

    if Player1.x + Player1.largura > comprimentoJanela then
      Player1.x = Player1.x - 5
    elseif 0 > Player1.x then
      Player1.x = Player1.x + 5
    end
end

local function movimentaP2(dt)
  if Player2.comando == ConstanteLove.comandoMoverDireita then
      Player2.x = Player2.x + 300 * dt
      jogo.encerraPartida = false
      jogo.mostrarMensagemInicial = false
    elseif Player2.comando == ConstanteLove.comandoMoverEsquerda then
      Player2.x = Player2.x - 300 * dt
      jogo.encerraPartida = false
      jogo.mostrarMensagemInicial = false
    end

    if Player2.x + Player2.largura > comprimentoJanela then
      Player2.x = Player2.x - 5
    elseif 0 > Player2.x then
      Player2.x = Player2.x + 5
    end
end

local function movimentaPlayer(comandoRecebido)
  Player2.comando = comandoRecebido
end

local function ObjetosDesenhaveis()
  love.graphics.setFont(jogo.fonte)
  if jogo.mostrarMensagemInicial == true then
    love.graphics.print("O primeiro a marcar 5 pontos vence!", 65, 200)
  end

  love.graphics.circle("fill", bola.posicao.X, bola.posicao.Y, bola.raio)
  love.graphics.setColor(1, 0, 0)
  love.graphics.setColor(1, 1, 1)

  love.graphics.rectangle("fill", Player1.x, Player1.y, Player1.largura, Player1.altura + 5)
  love.graphics.rectangle("fill", Player2.x, Player2.y, Player2.largura, Player2.altura + 5)
  love.graphics.print("P1 : " .. Player1.placar, 50, -10 + larguraJanela/2)
  love.graphics.print("P2 : " .. Player2.placar, comprimentoJanela - 150, -10 + larguraJanela/2)

  if Player1.placar == ConstanteLove.finalJogo  then
    love.graphics.print("P1 Venceu!", comprimentoJanela - 500, larguraJanela - 450)
    love.graphics.print("Pressione Enter para jogar novamente!", comprimentoJanela - 765, larguraJanela - 400)
    jogo.partidaTerminada = true
  elseif Player2.placar == ConstanteLove.finalJogo then
    love.graphics.print("P2 Venceu!", comprimentoJanela - 500, larguraJanela - 450)
    love.graphics.print("Pressione Enter para jogar novamente!", comprimentoJanela - 765, larguraJanela - 400)
    jogo.partidaTerminada = true
  end
end

local function restart()
  if love.keyboard.isDown("return") then
    jogo.partidaTerminada = false
    Player1.placar = 0
    Player2.placar = 0
  end
end

function love.load()
  construirJanela()
  MqttServer.start(ConstanteLove.hostServer, 'luca16s', ConstanteLove.canalJogo,  movimentaPlayer)
end

function love.update(dt)
  movimentaP1(dt)
  movimentaP2(dt)
  restart()
  if jogo.encerraPartida == false and jogo.partidaTerminada == false then
    movimentaBola(dt, bola)
  end
  MqttServer.checkMessages()
end

function love.draw()
  ObjetosDesenhaveis()
end