local ConstanteLove = require 'ConstanteLove'
local mqttLove = require "mqttLoveLibrary"

local comprimento, largura = love.graphics.getDimensions()
math.randomseed(os.time())
local ParaJogo=true

local bola = {
    raio = ConstanteLove.raioBola,
    posicao = {
        X = (comprimento / 2) - (ConstanteLove.raioBola / 2),
        Y = (largura / 2) - (ConstanteLove.raioBola / 2),
    },
    velocidade = {
        X = 200 * math.cos(math.random() * 2 * math.pi),
        Y = 200 * math.sin(math.random() * 2 * math.pi),
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
local placarP1=0
local placarP2=0

local retanguloP1={x=posicaoHorizontal,y=50,largura=ConstanteLove.comprimentoJogador,altura=ConstanteLove.alturaJogador,placar=placarP1}
local retanguloP2={x=posicaoHorizontal,y=posicaoVertical - 55,largura=ConstanteLove.comprimentoJogador,altura=ConstanteLove.alturaJogador,placar=placarP2}

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
    if bola.posicao.X > retanguloP1.x and retanguloP1.x+retanguloP1.largura>bola.posicao.X and retanguloP1.y+retanguloP1.altura> bola.posicao.Y-6 then
      bola.velocidade.Y = math.abs(bola.velocidade.Y)
      bola.velocidade.X=bola.velocidade.X+10
      bola.velocidade.Y=bola.velocidade.Y+10
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.X > retanguloP2.x and retanguloP2.x+retanguloP2.largura>bola.posicao.X and bola.posicao.Y+10>retanguloP2.y+retanguloP2.altura then --- MODIFICAR 
      bola.velocidade.Y = -math.abs(bola.velocidade.Y)
      bola.velocidade.X=bola.velocidade.X+10
      bola.velocidade.Y=bola.velocidade.Y+10
      bola.audio:stop() bola.audio:play()
    elseif retanguloP1.y>bola.posicao.Y+30 then
      bola.posicao.X = comprimento/2
      bola.posicao.Y = largura/2
      retanguloP1.x=posicaoHorizontal
      retanguloP2.x=posicaoHorizontal
      ParaJogo=true
      retanguloP2.placar=retanguloP2.placar+1
      mqttLove.sendMessage(ConstanteLove.comandoPontoJogador2, ConstanteLove.canal)
      bola.velocidade.X=200 * math.cos(math.random() * 2 * math.pi)
      bola.velocidade.Y=200 * math.sin(math.random() * 2 * math.pi)
    elseif bola.posicao.Y>retanguloP2.y+40 then
      bola.posicao.X = comprimento/2
      bola.posicao.Y = largura/2
      retanguloP1.x=posicaoHorizontal
      retanguloP2.x=posicaoHorizontal
      ParaJogo=true
      retanguloP1.placar=retanguloP1.placar+1
      mqttLove.sendMessage(ConstanteLove.comandoPontoJogador1, ConstanteLove.canal)
      bola.velocidade.X=200 * math.cos(math.random() * 2 * math.pi)
      bola.velocidade.Y=200 * math.sin(math.random() * 2 * math.pi)
  end
end
function movimentaP1(dt)
  if love.keyboard.isDown("right") then --- Movimentação do player 1
      retanguloP1.x=retanguloP1.x + 200*dt
      ParaJogo=false
    elseif love.keyboard.isDown("left") then
      retanguloP1.x=retanguloP1.x - 200*dt
      ParaJogo=false
    end
    if retanguloP1.x+retanguloP1.largura>comprimento then --- Colisão com o canto da tela
      retanguloP1.x=retanguloP1.x-5
    elseif 0>retanguloP1.x then
      retanguloP1.x=retanguloP1.x+5
    end
end

local function trataMensagemRecebida(mensagem)
end

function love.load()
  fonte=love.graphics.newFont(ConstanteLove.nomeFonte,24)
  construirJanela()
  mqttLove.start(ConstanteLove.hostServer, "luca16s", ConstanteLove.canal, trataMensagemRecebida)
end

function love.update(dt)
  mqttLove.checkMessages()
  movimentaP1(dt)
  if ParaJogo==false then
    movimentaBola(dt, bola)
  end
end

function love.draw()
  love.graphics.rectangle("fill", retanguloP1.x,retanguloP1.y , retanguloP1.largura,retanguloP1.altura)
  love.graphics.rectangle("fill", retanguloP2.x,retanguloP2.y , retanguloP2.largura,retanguloP2.altura)
  love.graphics.setFont(fonte)
  love.graphics.print("P1 : "..retanguloP1.placar,50,largura/2)
  love.graphics.print("P2 : "..retanguloP2.placar,comprimento-150,largura/2)
  love.graphics.circle("fill", bola.posicao.X, bola.posicao.Y, bola.raio)
end