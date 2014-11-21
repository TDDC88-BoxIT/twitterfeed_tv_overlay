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
function tv_info.set_decoded_tv_info()
local which_channel_n_date = "static/json/tv_info_svt2_1011.json"
local f = io.open(which_channel_n_date,"rb")
if f then 
  f:close() 
  print("error1 hejhej")
end	
if f ~= nil then
  local lines = ""
  for line in io.lines(which_channel_n_date) do 
    lines = lines .. line
    print("error2 hejhej")
  end
  
  -- This is where the json object is decoded
  print("error3 hejhej")
 decoded_tv_info = json:decode(lines)
 print("error4 hejhej")
  return decoded_tv_info
end
print("error5 hejhej")
return decoded_tv_info
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
  local decoded_info = tv_info.set_decoded_tv_info()
  print("decoded info: ", decoded_info)
  for k,v in pairs(decoded_info.jsontv.programme) do
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
  
    -- FINAL FUNCTION THAT RUNS ON OK KEYCLICK IN MENU
  -- input: chosen channel
  -- output: name of current show, name of channel (these can be modified to retreive more information)
  function get_current_prog_info(channel_name)
    local current_time = 1415579400
  --local current_time = tv_info.get_unixtimestamp()
  local relevant_tv_info = {}
  relevant_tv_info = tv_info.get_prog_relinfo(tv_info.get_prog_allinfo(current_time))  
  local current_prog_name = relevant_tv_info["name"]
  
return current_prog_name
end

function get_xmltv_info()
  
   
--local http = require "socket.http"
--local body,c,l,h = 
  --http.request([[http://json.xmltv.se/svt1.svt.se_2014-11-21.js.gz]])
 -- print('body', body)
  
  http = require"socket.http"
  print(http.request"http://json.xmltv.se/svt1.svt.se_2014-11-21.js.gz")
   
  -- svt1.svt.se_2014-11-21.js.gz 
  -- svt2.svt.se_2014-11-21.js.gz 
  -- tv3.se_2014-11-21.js.gz 
  -- tv4.se_2014-11-21.js.gz
  -- kanal5.se_2014-11-21.js.gz 
  -- tv6.se_2014-11-21.js.gz 
end
 

return tv_info
