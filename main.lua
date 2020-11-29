local ConstanteLove = require 'ConstanteLove'
local DecodificadorComando = require 'Decodificador'

local function construirJanela()
    love.window.setFullscreen(false)
    love.window.setTitle(ConstanteLove.TituloJogo)
    love.window.setIcon(love.image.newImageData(ConstanteLove.IconeJogo))
end

function love.load()
    construirJanela()
end

function love.update()
end

function love.draw()
end