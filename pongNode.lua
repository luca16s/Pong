local msgr = require 'mqttNodeMCULibrary'
local constNode = require 'ConstanteNode'

local sensor = 0
local ledVerde = 6
local ledVermelho = 3
local botaoDireito = 1
local botaoEsquerdo = 2

gpio.mode(ledVerde, gpio.OUTPUT)
gpio.mode(ledVermelho, gpio.OUTPUT)
gpio.write(ledVerde, gpio.LOW);
gpio.write(ledVermelho, gpio.LOW);

