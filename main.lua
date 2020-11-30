local ConstanteLove = require 'ConstanteLove'

local comprimento, largura = love.graphics.getDimensions()
local bola = {
    raio = ConstanteLove.raioBola,
    posicao = {
        X = (comprimento / 2) - (ConstanteLove.raioBola / 2),
        Y = (largura / 2) - (ConstanteLove.raioBola / 2),
    },
    velocidade = {
        base = 200,
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
end

function love.load()
    construirJanela()
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