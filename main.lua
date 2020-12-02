local ConstanteLove = require 'ConstanteLove'

math.randomseed(os.time())
local comprimento, largura = love.graphics.getDimensions()
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

local posicaoHorizontal, posicaoVertical = definirPosicaoCentralJogadores(ConstanteLove.comprimentoJogador)

local jogador1 = {
  x = posicaoHorizontal,
  y = 50,
  largura = ConstanteLove.comprimentoJogador,
  altura = ConstanteLove.alturaJogador
}

local jogador2 = {
  x = posicaoHorizontal,
  y = posicaoVertical - 55,
  largura = ConstanteLove.comprimentoJogador,
  altura = ConstanteLove.alturaJogador
}

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
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.Y > largura-bola.raio then
      bola.velocidade.Y = -math.abs(bola.velocidade.Y)
      bola.audio:stop() bola.audio:play()
    end

    if bola.posicao.X > jogador1.x and jogador1.x + jogador1.largura > bola.posicao.X and jogador1.y + jogador1.altura > bola.posicao.Y then
      bola.velocidade.Y = math.abs(bola.velocidade.Y)
      bola.audio:stop() bola.audio:play()
    elseif bola.posicao.X > jogador2.x and jogador2.x + jogador2.largura > bola.posicao.X and bola.posicao.Y>jogador2.y + jogador2.altura then --- MODIFICAR
      bola.velocidade.Y = math.abs(bola.velocidade.Y)
      bola.audio:stop() bola.audio:play()
  end
end

local function movimentaJogador1(dt)
  if love.keyboard.isDown("right") then
      jogador1.x = jogador1.x + 200*dt
    elseif love.keyboard.isDown("left") then
      jogador1.x = jogador1.x - 200*dt
    end
    if jogador1.x + jogador1.largura > comprimento then
      jogador1.x = jogador1.x - 5
    elseif 0 > jogador1.x then
      jogador1.x = jogador1.x + 5
    end
end

function love.load()
    construirJanela()
end

function love.update(dt)
  movimentaJogador1(dt)
    movimentaBola(dt, bola)
end

function love.draw()
  love.graphics.circle("fill", bola.posicao.X, bola.posicao.Y, bola.raio)
  love.graphics.rectangle("fill", jogador1.x,jogador1.y , jogador1.largura,jogador1.altura)
  love.graphics.rectangle("fill", posicaoHorizontal, posicaoVertical - 55, ConstanteLove.comprimentoJogador, ConstanteLove.alturaJogador)
end