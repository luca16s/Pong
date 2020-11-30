local ConstanteLove = require 'ConstanteLove'

local comprimento, largura = love.graphics.getDimensions()
local bola = {
    raio = ConstanteLove.raioBola,
    posicaoInicial = {
        X = (comprimento / 2) - (ConstanteLove.raioBola / 2),
        Y = (largura / 2) - (ConstanteLove.raioBola / 2)
    }
}

local function construirJanela()
    love.window.setFullscreen(false)
    love.window.setTitle(ConstanteLove.TituloJogo)
    love.window.setIcon(love.image.newImageData(ConstanteLove.IconeJogo))
end

local function definirPosicaoCentralJogadores(tamanhoRaquete)
    return (comprimento / 2) - (tamanhoRaquete / 2), largura
end

function love.load()
    construirJanela()
end

function love.update()
end

function love.draw()
  local posicaoHorizontal, posicaoVertical = definirPosicaoCentralJogadores(ConstanteLove.comprimentoJogador)

  love.graphics.rectangle("fill", posicaoHorizontal, 10, ConstanteLove.comprimentoJogador, ConstanteLove.alturaJogador)
  love.graphics.rectangle("fill", posicaoHorizontal, posicaoVertical - 10, ConstanteLove.comprimentoJogador, ConstanteLove.alturaJogador)

  love.graphics.circle("fill", bola.posicaoInicial.X, bola.posicaoInicial.Y, bola.raio)
end