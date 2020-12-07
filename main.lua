---------------------------------------------
local ConstanteLove = require 'ConstanteLove'
local mqttLove = require 'mqttLoveLibrary'
local comprimento, largura = love.graphics.getDimensions()
local ParaJogo=true
local FinalPartida=false
local placarP1=0
local placarP2=0
mensagem=false
math.randomseed(os.time())
---------------------------------------------
function defineCos()
  local angulosCos=math.random(55,90)
  local criterio=math.random(0,9)
  if criterio%2==1 then
    angulosCos=-angulosCos
  end
  return angulosCos
end
function defineSen()
  local angulosSen=math.random(55,90)
  local criterio=math.random(0,9)
  if criterio%2==1 then
    angulosSen=-angulosSen
  end
  return angulosSen
end
--
local bola = {
    raio = ConstanteLove.raioBola,
    posicao = {
        X = (comprimento / 2) - (ConstanteLove.raioBola / 2),
        Y = (largura / 2) - (ConstanteLove.raioBola / 2),
    },
    velocidade = {
        X = 10,
        Y = -200,
    },
    audio = love.audio.newSource(ConstanteLove.somBola, "static"),
}
  

local function construirJanela()
    love.window.setFullscreen(false)
    love.window.setTitle(ConstanteLove.TituloJogo)
    love.window.setIcon(love.image.newImageData(ConstanteLove.IconeJogo))
end

local function definirPosicaoCentralJogadores(tamanhoRaquete)
    return (comprimento / 2) - (tamanhoRaquete / 2), largura
end
posicaoHorizontal, posicaoVertical = definirPosicaoCentralJogadores(ConstanteLove.comprimentoJogador)
local P1={x=posicaoHorizontal,y=10,largura=ConstanteLove.comprimentoJogador,altura=ConstanteLove.alturaJogador,placar=placarP1}
local P2={x=posicaoHorizontal,y=posicaoVertical - 20,largura=ConstanteLove.comprimentoJogador,altura=ConstanteLove.alturaJogador,placar=placarP2}

local function movimentaBola(velocidade, bola)
    bola.posicao.X = bola.posicao.X + bola.velocidade.X * velocidade
    bola.posicao.Y = bola.posicao.Y + bola.velocidade.Y * velocidade
    if bola.posicao.X < bola.raio then
      bola.velocidade.X = math.abs(bola.velocidade.X)
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.X > comprimento-bola.raio then
      bola.velocidade.X = -math.abs(bola.velocidade.X)
      bola.audio:stop() bola.audio:play()
    end
    if bola.posicao.Y < bola.raio then
      bola.velocidade.Y = math.abs(bola.velocidade.Y)
      bola.velocidade.X=bola.velocidade.X+50
      bola.velocidade.Y=bola.velocidade.Y+50
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.Y > largura-bola.raio then
      bola.velocidade.Y = -math.abs(bola.velocidade.Y)
      bola.audio:stop() bola.audio:play()
    end
    if bola.posicao.X > P1.x and P1.x+P1.largura>bola.posicao.X and P1.y+P1.altura> bola.posicao.Y-20 and 0>bola.velocidade.Y then
      bola.velocidade.Y = math.abs(bola.velocidade.Y)
      bola.velocidade.X=bola.velocidade.X+20
      bola.velocidade.Y=bola.velocidade.Y+20
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.X > P2.x and P2.x+P2.largura>bola.posicao.X and bola.posicao.Y+20>P2.y+P2.altura and bola.velocidade.Y>0 then 
      bola.velocidade.Y = -math.abs(bola.velocidade.Y)
      bola.velocidade.X=bola.velocidade.X-20
      bola.velocidade.Y=bola.velocidade.Y-20
      bola.audio:stop() bola.audio:play()
    --- Critério para pontuação ---
    elseif P1.y-P1.altura/2>bola.posicao.Y then
      bola.posicao.X = comprimento/2
      bola.posicao.Y = largura/2
      P1.x=posicaoHorizontal
      P2.x=posicaoHorizontal
      ParaJogo=true
      P2.placar=P2.placar+1
      bola.velocidade.X=2*defineCos()
      bola.velocidade.Y=2*defineSen()
    elseif bola.posicao.Y>P2.y+P2.altura/2 then
      bola.posicao.X = comprimento/2
      bola.posicao.Y = largura/2
      P1.x=posicaoHorizontal
      P2.x=posicaoHorizontal
      ParaJogo=true
      P1.placar=P1.placar+1
      bola.velocidade.X=2*defineCos()
      bola.velocidade.Y=2*defineSen()
  end
end
function movimentaP1(dt)
  if love.keyboard.isDown("right") then --- Movimentação do player 1 
      P1.x=P1.x + 300*dt
      ParaJogo=false
      mensagem=true
    elseif love.keyboard.isDown("left") then
      P1.x=P1.x - 300*dt
      ParaJogo=false
      mensagem=true
    end
    if P1.x+P1.largura>comprimento then --- Colisão com o canto da tela
      P1.x=P1.x-5
    elseif 0>P1.x then
      P1.x=P1.x+5
    end
end
function restart()
  if love.keyboard.isDown("return") then
    FinalPartida=false
    P1.placar=0
    P2.placar=0
  end
end
function love.load()
  fonte=love.graphics.newFont(ConstanteLove.nomeFonte, 24)
  --mqttLove.start(ConstanteLove.hostServer, "luca16s", ConstanteLove.canal, trataMensagemRecebida)
  construirJanela()
end
function love.update(dt)
  movimentaP1(dt)
  restart()
  if ParaJogo==false and FinalPartida==false then
    movimentaBola(dt, bola) 

end
end
function ObjetosDesenhaveis()
  love.graphics.setFont(fonte)
  if mensagem==false then
    love.graphics.print("O primeiro a marcar 5 pontos vence!",65,200)
  end
  love.graphics.rectangle("fill", P1.x,P1.y ,P1.largura,P1.altura+5)
  love.graphics.rectangle("fill", P2.x,P2.y ,P2.largura,P2.altura+5)
  love.graphics.print("P1 : "..P1.placar,50,-10+largura/2)
  love.graphics.print("P2 : "..P2.placar,comprimento-150,-10+largura/2)
  love.graphics.circle("fill", bola.posicao.X, bola.posicao.Y, bola.raio)
  if P1.placar==2  then
    love.graphics.print("P1 Venceu!",comprimento-500,largura-450)
    love.graphics.print("Pressione Enter para jogar novamente!",comprimento-765,largura-400)
    FinalPartida=true
  elseif P2.placar==2 then
    love.graphics.print("P2 Venceu!",comprimento-500,largura-450)
    love.graphics.print("Pressione Enter para jogar novamente!",comprimento-765,largura-400)
    FinalPartida=true
  end
end
function love.draw()
  ObjetosDesenhaveis()
end