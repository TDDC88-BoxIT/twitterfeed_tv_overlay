json = require("scrum1.json")
local tv_info = {}

--- Returns a table containing available channels.
-- Returns a table with available channels. Can be called upon in main.lua like so: 'channel_list = tv_info.get_channel_list()'
-- @return a table with available channels.
-- @author Gustav B-N, Joel
function tv_info.get_channel_list()
	local channel_list = {"SVT1", "SVT2", "TV3", "TV4", "Kanal 5", "TV6", "Kanal 7", "TV8", "Kanal 9", "TV10", "11an"}
	return channel_list;
end

--Understand json files about tv_schedule
--Make mockup harcoding the json file in static folder and take info from there
--Fetch the relevant information from this (program_name, start_time, - -end_time)
--ev input for algorithm (actor_name, .... lots of info) low prio

-- This part simulates receiving tv_info, it reads a json object from a file and decodes it
-- will be removed when we get ip-connection
local which_channel_n_date = "scrum1/static/json/tv_info_svt2_1011.json"
local f = io.open(which_channel_n_date,"rb")
if f then 
  f:close() 
end	
if f ~= nil then
  local lines = ""
  for line in io.lines(which_channel_n_date) do 
    lines = lines .. line
  end
  
  -- This is where the json object is decoded
  decoded_tv_info = json:decode(lines)
end

--- Gets the time in unix timestamp format.
-- @return an integer of the current unixtimestamp
-- @author Joel
function tv_info.get_unixtimestamp()
  return os.time()
end
  
--- Returns information about TV shows based on scheduled time.
-- Fetches 15 tweets based on a search key and returns them in reverse order. 
-- @param current_time an integer formated in unixtimestamp.
-- @return a table all information about the tv show
-- @author Joel
function tv_info.get_prog_allinfo(current_time)
  for k,v in pairs(decoded_tv_info.jsontv.programme) do
    if tonumber(v.start) <= current_time and tonumber(v.stop) > current_time then
     allinfo = v
    end
  end
  return allinfo
end

--- Extracts relevant TV information from a table.
-- @param table_allinfo a table with all TV information.
-- @return a table with relevant TV information.
-- @author Joel
function tv_info.get_prog_relinfo(table_allinfo)
  table_relinfo = {}
  table_relinfo["name"] = table_allinfo.title.sv
  table_relinfo["start"] = table_allinfo.start  -- not converted to real date
  table_relinfo["stop"] = table_allinfo.stop    -- not converted to real date
  return table_relinfo
end
  
return tv_info
