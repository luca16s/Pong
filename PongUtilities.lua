PongUtilities = {}

function PongUtilities.CopiarTabela(tabelaOriginal)
  local tabelaEspelho
  if type(tabelaOriginal) == 'table' then
      tabelaEspelho = {}
      for chaveOriginal, valorOriginal in next, tabelaOriginal, nil do
          tabelaEspelho[PongUtilities.CopiarTabela(chaveOriginal)] = PongUtilities.CopiarTabela(valorOriginal)
      end
      setmetatable(tabelaEspelho, PongUtilities.CopiarTabela(getmetatable(tabelaOriginal)))
  else
      tabelaEspelho = tabelaOriginal
  end
  return tabelaEspelho
end

return PongUtilities