local mqtt = require 'mqttNodeMCULibrary'

local sensor = 0
local ledJogador1 = 6
local ledJogador2 = 3
local botaoDireito = 1
local botaoEsquerdo = 2
local ultimaAcao = nil

local hostServer = '192.168.1.2'
local canalJogo = 'PONG_LUA_GAME'
local comandoMoverEsquerda = '<PONG><MOVE><LEFT>'
local comandoMoverDireita = '<PONG><MOVE><RIGHT>'
local comandoParar = '<PONG><STOP>'
local comandoVelocidadeBola = '<PONG><%f>'
local comandoPontoJogador1 = '<PONG><LIGHT><GREEN>'
local comandoPontoJogador2 = '<PONG><LIGHT><RED>'

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
      print('3')
      gpio.write(ledJogador2, gpio.LOW)
      gpio.write(ledJogador1, gpio.HIGH)
    elseif comando == comandoPontoJogador2 then
      print('4')
      gpio.write(ledJogador1, gpio.LOW)
      gpio.write(ledJogador2, gpio.HIGH)
    end
    mensagemVelocidadeBola(string.format(comandoVelocidadeBola, adc.read(sensor)), canalJogo)
  end
end

gpio.mode(botaoDireito, gpio.INPUT, gpio.PULLUP)
gpio.mode(botaoEsquerdo, gpio.INPUT, gpio.PULLUP)
gpio.trig(botaoDireito, 'both', mandaMensagemDireita)
gpio.trig(botaoEsquerdo, 'both', mandaMensagemEsquerda)

mqtt.start(hostServer, 'Paulo', canalJogo, comandoRecebido)
