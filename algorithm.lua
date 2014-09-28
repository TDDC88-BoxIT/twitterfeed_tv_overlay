--http://json.luaforge.net/
local io = require("io")
local json = require("json")
--Tests if the variable is present
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end
--Writes all the lines from file to the string lines
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = ""
  for line in io.lines(file) do 
    lines = lines .. line
  end
  return lines
end
--tror jag har problem med line endings
local lines = lines_from("json.txt")
--Dessa raderska decoda json och printa table
parsed = json.decode(lines)
table.foreach(parsed,print)

