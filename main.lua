local ConstanteLove = require 'ConstanteLove'

local comprimento, largura = love.graphics.getDimensions()
local audioBola
local bola = {
    raio = ConstanteLove.raioBola,
    posicao = {
        X = (comprimento / 2) - (ConstanteLove.raioBola / 2),
        Y = (largura / 2) - (ConstanteLove.raioBola / 2)
    },
    velocidade = {
        base = 200,
        X = 0,
        Y = 0
    },
}

local function construirJanela()
    love.window.setFullscreen(false)
    love.window.setTitle(ConstanteLove.TituloJogo)
    love.window.setIcon(love.image.newImageData(ConstanteLove.IconeJogo))
end

local function definirPosicaoCentralJogadores(tamanhoRaquete)
    return (comprimento / 2) - (tamanhoRaquete / 2), largura
end

local function movimentaBola(velocidade, bola)
    bola.posicao.X = bola.posicao.X + bola.velocidade.x*velocidade
    bola.posicao.Y = bola.posicao.Y + bola.velocidade.y*velocidade
    if bola.posicao.X < bola.raio then
      bola.velocidade.x = math.abs(bola.velocidade.x)
      audioBola:stop() audioBola:play()
    elseif bola.posicao.X > comprimento-bola.raio then
      bola.velocidade.x = -math.abs(bola.velocidade.x)
      audioBola:stop() audioBola:play()
    end
    if bola.posicao.Y < bola.raio then
      bola.velocidade.y = math.abs(bola.velocidade.y)
      audioBola:stop() audioBola:play()
    elseif bola.posicao.Y > largura-bola.raio then
      bola.velocidade.y = -math.abs(bola.velocidade.y)
      audioBola:stop() audioBola:play()
    end
end

function love.load()
    construirJanela()
    audioBola = love.audio.newSource(ConstanteLove.somBola, "static")
    bola.velocidade.x = bola.velocidade.base * math.cos(math.random() * 2 * math.pi)
    bola.velocidade.y = bola.velocidade.base * math.sin(math.random() * 2 * math.pi)
end

function love.update(dt)
    movimentaBola(dt, bola)
end

function love.draw()
  local posicaoHorizontal, posicaoVertical = definirPosicaoCentralJogadores(ConstanteLove.comprimentoJogador)

  love.graphics.rectangle("fill", posicaoHorizontal, 5, ConstanteLove.comprimentoJogador, ConstanteLove.alturaJogador)
  love.graphics.rectangle("fill", posicaoHorizontal, posicaoVertical - 10, ConstanteLove.comprimentoJogador, ConstanteLove.alturaJogador)

  love.graphics.circle("fill", bola.posicao.X, bola.posicao.Y, bola.raio)
end