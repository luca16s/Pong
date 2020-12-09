PongUtilities = {}

function PongUtilities.CopiarTabela(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[PongUtilities.CopiarTabela(orig_key)] = PongUtilities.CopiarTabela(orig_value)
      end
      setmetatable(copy, PongUtilities.CopiarTabela(getmetatable(orig)))
  else
      copy = orig
  end
  return copy
end

return PongUtilities