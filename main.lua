local ObjetosPong = require 'PongObjects'
local MqttServer = require 'mqttLoveLibrary'
local ConstanteLove = require 'ConstanteLove'
local PongUtilities = require 'PongUtilities'

local Jogo = PongUtilities.CopiarTabela(ObjetosPong.Jogo)
local Bola = PongUtilities.CopiarTabela(ObjetosPong.Bola)
local Jogador1 = PongUtilities.CopiarTabela(ObjetosPong.Player1)
local Jogador2 = PongUtilities.CopiarTabela(ObjetosPong.Player2)

local function construirJanela()
  love.window.setMode(ConstanteLove.comprimentoJanela, ConstanteLove.larguraJanela)
    love.window.setFullscreen(false)
    love.window.setTitle(ConstanteLove.TituloJogo)
    love.window.setIcon(love.image.newImageData(ConstanteLove.IconeJogo))
end

local function movimentaBola(velocidade, jogo, bola, jogador1, jogador2)
    bola.posicao.X = bola.posicao.X + bola.velocidade.X * velocidade
    bola.posicao.Y = bola.posicao.Y + bola.velocidade.Y * velocidade

    if bola.posicao.X < bola.raio then
      bola.velocidade.X = math.abs(bola.velocidade.X)
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.X > ConstanteLove.comprimentoJanela - bola.raio then
      bola.velocidade.X = -math.abs(bola.velocidade.X)
      bola.audio:stop() bola.audio:play()
    end

    if bola.posicao.Y < bola.raio then
      bola.velocidade.Y = math.abs(bola.velocidade.Y)
      bola.velocidade.X = bola.velocidade.X
      bola.velocidade.Y = bola.velocidade.Y
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.Y > ConstanteLove.larguraJanela - bola.raio then
      bola.velocidade.Y = -math.abs(bola.velocidade.Y)
      bola.audio:stop() bola.audio:play()
    end

    if bola.posicao.X > jogador1.X and jogador1.X + jogador1.largura > bola.posicao.X and jogador1.Y + jogador1.altura > bola.posicao.Y-20 and 0 > bola.velocidade.Y then
      bola.velocidade.Y = math.abs(bola.velocidade.Y)
      bola.velocidade.X = bola.velocidade.X + 50
      bola.velocidade.Y = bola.velocidade.Y + 50
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.X > jogador2.X and jogador2.X + jogador2.largura > bola.posicao.X and bola.posicao.Y + 20 > jogador2.Y + jogador2.altura and bola.velocidade.Y > 0 then
      bola.velocidade.Y = -math.abs(bola.velocidade.Y)
      bola.velocidade.X = bola.velocidade.X - 50
      bola.velocidade.Y = bola.velocidade.Y - 50
      bola.audio:stop() bola.audio:play()
    elseif jogador1.Y - jogador1.altura/2 > bola.posicao.Y then
      bola.posicao.X = ConstanteLove.comprimentoJanela/2
      bola.posicao.Y = ConstanteLove.larguraJanela/2
      jogador1.X = ObjetosPong.posicaoHorizontal
      jogador2.X = ObjetosPong.posicaoHorizontal
      jogador2.placar = jogador2.placar + 1
      jogo.iniciarPartida = false
      MqttServer.sendMessage(ConstanteLove.comandoPontoJogador2, ConstanteLove.canalJogo)
      bola.velocidade.X = 2 * ObjetosPong.defineAngulo()
      bola.velocidade.Y = 2 * ObjetosPong.defineAngulo()
    elseif bola.posicao.Y > jogador2.Y + jogador2.altura/2 then
      bola.posicao.X = ConstanteLove.comprimentoJanela/2
      bola.posicao.Y = ConstanteLove.larguraJanela/2
      jogador1.X = ObjetosPong.posicaoHorizontal
      jogador2.X = ObjetosPong.posicaoHorizontal
      jogador1.placar = jogador1.placar + 1
      jogo.iniciarPartida = false
      MqttServer.sendMessage(ConstanteLove.comandoPontoJogador1, ConstanteLove.canalJogo)
      bola.velocidade.X = 2 * ObjetosPong.defineAngulo()
      bola.velocidade.Y = 2 * ObjetosPong.defineAngulo()
    end
end

local function realizarMovimento(jogo, jogador, movimento, velocidade)
  jogador.X = jogador.X + movimento * velocidade
  jogo.mostrarMensagemInicial = false
  jogo.iniciarPartida = true
end

local function validaColisaoJogador(jogador, comprimentoJanela)
  if jogador.X + jogador.largura > comprimentoJanela then
    jogador.X = jogador.X - 5
  elseif 0 > jogador.X then
    jogador.X = jogador.X + 5
  end
end

local function movimentarPersonagem(jogador, jogo, velocidade)
  if jogo.finalizarPartida == false then
    if jogador.comando == ConstanteLove.comandoMoverDireita then
      realizarMovimento(jogo, jogador, 300, velocidade)
    elseif jogador.comando == ConstanteLove.comandoMoverEsquerda then
      realizarMovimento(jogo, jogador, -300, velocidade)
    end
  end
  validaColisaoJogador(jogador, ConstanteLove.comprimentoJanela)
end

local function movimentaPlayerNode(comandoRecebido)
  Jogador2.comando = comandoRecebido
end

local function reiniciarJogo()
  Jogo = PongUtilities.CopiarTabela(ObjetosPong.Jogo)
  Bola = PongUtilities.CopiarTabela(ObjetosPong.Bola)
  Jogador1 = PongUtilities.CopiarTabela(ObjetosPong.Player1)
  Jogador2 = PongUtilities.CopiarTabela(ObjetosPong.Player2)
  MqttServer.sendMessage(ConstanteLove.comandoApagarLeds, ConstanteLove.canalJogo)
end

function love.load()
  construirJanela()
  MqttServer.start(ConstanteLove.hostServer, 'luca16s', ConstanteLove.canalJogo,  movimentaPlayerNode)
end

function love.update(dt)
  if Jogo.pausarPartida == false then
    movimentarPersonagem(Jogador1, Jogo, dt)
    movimentarPersonagem(Jogador2, Jogo, dt)

    if Jogo.reiniciarPartida then
      reiniciarJogo()
    end

    if Jogo.iniciarPartida and Jogo.finalizarPartida == false then
      movimentaBola(dt, Jogo, Bola, Jogador1, Jogador2)
    end

    MqttServer.checkMessages()
  end
end

function love.draw()
  love.graphics.setFont(Jogo.fonte)

  if Jogo.mostrarMensagemInicial then
    love.graphics.print(string.format("O primeiro a marcar %d pontos vence!", ConstanteLove.pontuacaoFinalJogo), 65, 200)
  end

  love.graphics.circle("fill", Bola.posicao.X, Bola.posicao.Y, Bola.raio)
  love.graphics.setColor(1, 0, 0)
  love.graphics.setColor(1, 1, 1)

  love.graphics.rectangle("fill", Jogador1.X, Jogador1.Y, Jogador1.largura, Jogador1.altura + 5)
  love.graphics.rectangle("fill", Jogador2.X, Jogador2.Y, Jogador2.largura, Jogador2.altura + 5)

  love.graphics.print(string.format("P1 : %d", Jogador1.placar), 50, -10 + ConstanteLove.larguraJanela/2)
  love.graphics.print(string.format("P2 : %d", Jogador2.placar), ConstanteLove.comprimentoJanela - 150, -10 + ConstanteLove.larguraJanela/2)

  if Jogador1.placar == ConstanteLove.pontuacaoFinalJogo  then
    love.graphics.print("P1 Venceu!", ConstanteLove.comprimentoJanela - 500, ConstanteLove.larguraJanela - 450)
    love.graphics.print("Pressione Enter para jogar novamente!", ConstanteLove.comprimentoJanela - 765, ConstanteLove.larguraJanela - 400)
    Jogo.finalizarPartida = true
  elseif Jogador2.placar == ConstanteLove.pontuacaoFinalJogo then
    love.graphics.print("P2 Venceu!", ConstanteLove.comprimentoJanela - 500, ConstanteLove.larguraJanela - 450)
    love.graphics.print("Pressione Enter para jogar novamente!", ConstanteLove.comprimentoJanela - 765, ConstanteLove.larguraJanela - 400)
    Jogo.finalizarPartida = true
  end
end

function love.keypressed(key)
    if key == 'left' then
      Jogador1.comando = ConstanteLove.comandoMoverEsquerda
    elseif key == 'right' then
      Jogador1.comando = ConstanteLove.comandoMoverDireita
    elseif key == 'return' then
      Jogo.reiniciarPartida = true
    elseif key == 'space' then
      if Jogo.pausarPartida then
        Jogo.pausarPartida = false
      else
        Jogo.pausarPartida = true
      end
    elseif key == 'escape' then
      local buttons = { "Não", "Sim", escapebutton = 2 }
      if love.window.showMessageBox('PongLua', 'Deseja Encerrar o jogo?', buttons) == 2 then
        love.event.quit()
      end
    end
end

function love.keyreleased(key)
  if key == 'left' or key == 'right' then
    Jogador1.comando = ConstanteLove.comandoParar
  end
end