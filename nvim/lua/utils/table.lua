---Deduplicate a list of strings, removing empty entries, and sort the result.
---@param list string[]
---@return string[]
local function uniq(list)
  local seen = {}
  local out = {}
  for _, item in ipairs(list) do
    if type(item) == "string" and item ~= "" and not seen[item] then
      seen[item] = true
      table.insert(out, item)
    end
  end
  table.sort(out)
  return out
end

return { uniq = uniq }
