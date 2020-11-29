local ConstanteLove = require 'ConstanteLove'
local DecodificadorComando = require 'Decodificador'

local function construirJanela()
    love.window.setFullscreen(false)
    love.window.setTitle(ConstanteLove.TituloJogo)
    love.window.setIcon(love.image.newImageData(ConstanteLove.IconeJogo))
end

local function definirPosicaoCentralJogadores(tamanhoRaquete)
    local comprimento, largura = love.graphics.getDimensions()
    return (comprimento / 2) - (tamanhoRaquete / 2), largura
end

local function definirPosicaoCentralBola(tamanhoBola)
    local comprimento, largura = love.graphics.getDimensions()
    return (comprimento / 2) - (tamanhoBola / 2), (largura / 2) - (tamanhoBola / 2)
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

  local posicaoBolaX, posicaoBolaY = definirPosicaoCentralBola(ConstanteLove.tamanhoBola)
  love.graphics.circle("fill", posicaoBolaX, posicaoBolaY, ConstanteLove.tamanhoBola)
end