local mqtt = require 'mqttNodeMCULibrary'
local ConstanteNode = require 'ConstanteNode'

local sensor = 0
local ledVerde = 6
local ledVermelho = 3
local botaoDireito = 1
local botaoEsquerdo = 2
local ultimaAcao = nil

gpio.mode(ledVerde, gpio.OUTPUT)
gpio.mode(ledVermelho, gpio.OUTPUT)
gpio.write(ledVerde, gpio.LOW)
gpio.write(ledVermelho, gpio.LOW)

local function mensagemVelocidadeBola(mensagem, canal)
    mqtt.sendMessage(mensagem, canal)
end

local function mandaMensagemDireita(level)
    if level ~= ultimaAcao then
      ultimaAcao = level
      if level == 0 then
        mqtt.sendMessage(ConstanteNode.comandoMoverDireita, ConstanteNode.canalJogo)
      elseif level == 1 then
        mqtt.sendMessage(ConstanteNode.comandoParar, ConstanteNode.canalJogo)
      end
    end
  end

  local function mandaMensagemEsquerda(level)
    if level ~= ultimaAcao then
      ultimaAcao = level
      if level == 0 then
        mqtt.sendMessage(ConstanteNode.comandoMoverEsquerda, ConstanteNode.canalJogo)
      elseif level == 1 then
        mqtt.sendMessage(ConstanteNode.comandoParar, ConstanteNode.canalJogo)
      end
    end
  end

local function comandoRecebido(comando)
    if comando == ConstanteNode.Jogador1 then
        gpio.write(ledVerde, gpio.HIGH)
        gpio.write(ledVermelho, gpio.LOW)
    elseif comando == ConstanteNode.Jogador2 then
        gpio.write(ledVerde, gpio.HIGH)
        gpio.write(ledVermelho, gpio.LOW)
    end
    mensagemVelocidadeBola(string.format(ConstanteNode.comandoVelocidadeBola, adc.read(sensor)), ConstanteNode.canalBola)
end

gpio.mode(botaoDireito, gpio.INPUT, gpio.PULLUP)
gpio.mode(botaoEsquerdo, gpio.INPUT, gpio.PULLUP)
gpio.trig(botaoDireito, 'both', mandaMensagemDireita)
gpio.trig(botaoEsquerdo, 'both', mandaMensagemEsquerda)

mqtt.start(ConstanteNode.hostServer, ConstanteNode.canalJogo, comandoRecebido)
