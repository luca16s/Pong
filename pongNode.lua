local mqtt = require 'mqttNodeMCULibrary'

local sensor = 0
local ultimaAcao = nil
local ledJogador1 = 6
local ledJogador2 = 3
local botaoDireito = 1
local botaoEsquerdo = 2

local comandoParar = 'STOP'
local canalJogo = 'PONG_LUA_GAME'
local hostServer = '192.168.1.2'
local comandoApagarLed = 'OFF'
local comandoMoverDireita = 'RIGHT'
local comandoPontoJogador2 = 'RED'
local comandoMoverEsquerda = 'LEFT'
local comandoPontoJogador1 = 'GREEN'
local comandoVelocidadeBola = '%f'

gpio.mode(ledJogador1, gpio.OUTPUT)
gpio.mode(ledJogador2, gpio.OUTPUT)
gpio.write(ledJogador1, gpio.LOW)
gpio.write(ledJogador2, gpio.LOW)

local function mensagemVelocidadeBola(mensagem, canal)
    mqtt.sendMessage(mensagem, canal)
end

local function mandaMensagemDireita(level)
    if level ~= ultimaAcao then
      ultimaAcao = level
      if level == 0 then
        mqtt.sendMessage(comandoMoverDireita, canalJogo)
      elseif level == 1 then
        mqtt.sendMessage(comandoParar, canalJogo)
      end
    end
  end

  local function mandaMensagemEsquerda(level)
    if level ~= ultimaAcao then
      ultimaAcao = level
      if level == 0 then
        mqtt.sendMessage(comandoMoverEsquerda, canalJogo)
      elseif level == 1 then
        mqtt.sendMessage(comandoParar, canalJogo)
      end
    end
  end

local function comandoRecebido(comando)
  if comando == comandoPontoJogador1 or comando == comandoPontoJogador2 then
    if comando == comandoPontoJogador1 then
      gpio.write(ledJogador2, gpio.LOW)
      gpio.write(ledJogador1, gpio.HIGH)
    elseif comando == comandoPontoJogador2 then
      gpio.write(ledJogador1, gpio.LOW)
      gpio.write(ledJogador2, gpio.HIGH)
    end
    mensagemVelocidadeBola(string.format(comandoVelocidadeBola, adc.read(sensor)), canalJogo)
  end
  if comando == comandoApagarLed then
    gpio.write(ledJogador1, gpio.LOW)
    gpio.write(ledJogador2, gpio.LOW)
  end
end

gpio.mode(botaoDireito, gpio.INPUT, gpio.PULLUP)
gpio.mode(botaoEsquerdo, gpio.INPUT, gpio.PULLUP)
gpio.trig(botaoDireito, 'both', mandaMensagemDireita)
gpio.trig(botaoEsquerdo, 'both', mandaMensagemEsquerda)

mqtt.start(hostServer, 'luca16s', canalJogo, comandoRecebido)
