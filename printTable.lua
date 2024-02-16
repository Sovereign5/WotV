function PrintTable(t, indent)
  assert(type(t) == "table", "PrintTable() called for non-table!")
 
  local indentString = ""
  for i = 1, indent do
    indentString = indentString .. "  "
  end
 
  for k, v in pairs(t) do
    if type(v) ~= "table" then
      if type(v) == "string" then
        print(indentString, k, "=", v)
      end
    else
      print(indentString, k, "=")
      print(indentString, "  {")
      PrintTable(v, indent + 2)
      print(indentString, "  }")
    end
  end
end