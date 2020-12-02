local mqtt = require 'mqttNodeMCULibrary'
local ConstanteNode = require 'ConstanteNode'

local sensor = 0
local ledJogador1 = 6
local ledJogador2 = 3
local botaoDireito = 1
local botaoEsquerdo = 2
local ultimaAcao = nil

gpio.mode(ledJogador1, gpio.OUTPUT)
gpio.mode(ledJogador2, gpio.OUTPUT)

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
    if comando == ConstanteNode.comandoPontoJogador1 then
        gpio.write(ledJogador2, gpio.LOW)
        gpio.write(ledJogador1, gpio.HIGH)
    elseif comando == ConstanteNode.comandoPontoJogador2 then
        gpio.write(ledJogador2, gpio.LOW)
        gpio.write(ledJogador1, gpio.HIGH)
    end
    mensagemVelocidadeBola(string.format(ConstanteNode.comandoVelocidadeBola, adc.read(sensor)), ConstanteNode.canalBola)
end

gpio.mode(botaoDireito, gpio.INPUT, gpio.PULLUP)
gpio.mode(botaoEsquerdo, gpio.INPUT, gpio.PULLUP)
gpio.trig(botaoDireito, 'both', mandaMensagemDireita)
gpio.trig(botaoEsquerdo, 'both', mandaMensagemEsquerda)

mqtt.start(ConstanteNode.hostServer, 'Paulo',ConstanteNode.canalJogo, comandoRecebido)
