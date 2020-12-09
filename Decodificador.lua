Decodificador = {}

function Decodificador.velocidadePlayer(mensagemRecebida)
    return string.sub(string.match(mensagemRecebida, '<%w[%w.]*>'), 2, -2)
  end

return Decodificador