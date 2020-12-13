local ConstanteLove = require 'PongConstanteLove'
PongObjects = {}

PongObjects.posicaoHorizontal = (ConstanteLove.comprimentoJanela / 2) - (ConstanteLove.comprimentoJogador / 2)
math.randomseed(os.time())

function PongObjects.defineAngulo()
  local angulo = math.random(55, 90)
  local criterio = math.random(0, 9)

  if criterio%2 == 1 then
    angulo = -angulo
  end
  return angulo
end

PongObjects.Jogo = {
    fonte = love.graphics.newFont(ConstanteLove.nomeFonte, ConstanteLove.tamanhoFonte),
    imagem = love.graphics.newImage(ConstanteLove.imagemFundo),
    mostrarMensagemInicial = true,
    iniciarPartida = false,
    pausarPartida = false,
    reiniciarPartida = false,
    finalizarPartida = false
}

PongObjects.Bola = {
      imagem = love.graphics.newImage(ConstanteLove.imagemBola),
      raio = ConstanteLove.raioBola,
      posicao = {
          X = (ConstanteLove.comprimentoJanela / 2) - (ConstanteLove.raioBola / 2),
          Y = (ConstanteLove.larguraJanela / 2) - (ConstanteLove.raioBola / 2),
      },
      velocidade = {
          X = 10,
          Y = -200,
      },
      audio = love.audio.newSource(ConstanteLove.somBola, 'static'),
}

PongObjects.Player1 = {
    imagem = love.graphics.newImage(ConstanteLove.imagemPlataforma1),
    X = PongObjects.posicaoHorizontal,
    Y = 10,
    largura = ConstanteLove.comprimentoJogador,
    altura = ConstanteLove.alturaJogador,
    placar = 0,
    comando = nil
}

PongObjects.Player2 = {
    imagem = love.graphics.newImage(ConstanteLove.imagemPlataforma2),
    X = PongObjects.posicaoHorizontal,
    Y = ConstanteLove.larguraJanela - 20,
    largura = ConstanteLove.comprimentoJogador,
    altura = ConstanteLove.alturaJogador,
    placar = 0,
    comando = nil
}

  return PongObjects