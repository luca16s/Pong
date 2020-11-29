local mqtt = require 'mqttNodeMCULibrary'
local ConstanteNode = require 'ConstanteNode'

local sensor = 0
local ledVerde = 6
local ledVermelho = 3
local botaoDireito = 1
local botaoEsquerdo = 2

gpio.mode(ledVerde, gpio.OUTPUT)
gpio.mode(ledVermelho, gpio.OUTPUT)
gpio.write(ledVerde, gpio.LOW);
gpio.write(ledVermelho, gpio.LOW);

local function mandaComando(mensagem, canal)
    mqtt.sendMessage(mensagem, canal)
end

local function comandoRecebido(comando)
    mandaComando(string.format(ConstanteNode.comandoVelocidadeBola, adc.read(sensor)), ConstanteNode.canalBola)
    print(comando)
    if 1 == 1 then
        gpio.write(ledVerde, gpio.HIGH);
        gpio.write(ledVermelho, gpio.LOW);
        elseif 2 == 2 then
            gpio.write(ledVerde, gpio.HIGH);
            gpio.write(ledVermelho, gpio.LOW);
    end
end

gpio.mode(botaoDireito, gpio.INPUT, gpio.PULLUP)
gpio.mode(botaoEsquerdo, gpio.INPUT, gpio.PULLUP)
gpio.trig(botaoDireito, 'both', mandaComando(ConstanteNode.comandoMoverDireita, ConstanteNode.canalJogo))
gpio.trig(botaoEsquerdo, 'both', mandaComando(ConstanteNode.comandoMoverEsquerda, ConstanteNode.canalJogo))

mqtt.start(ConstanteNode.hostServer, ConstanteNode.canalJogo, comandoRecebido)