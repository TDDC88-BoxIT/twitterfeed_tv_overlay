
json = require("scrum1.json")

local tv_info = {}
-- Returns a table with available channels. Can be called upon in main.lua like so: 'channel_list = tv_info.get_channel_list()' 
function tv_info.get_channel_list()
	local channel_list = {"SVT1", "SVT2", "TV3", "TV4", "Kanal 5", "TV6"}
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
  
  --Gets the time in unix timestamp format. coverting it to swedish winter time during UK winter time
  -- other convertions do not currently work
  function tv_info.get_unixtimestamp()
    return os.time()
  end
  
  --function that takes the current time (number) and matches it against start and end time of
  --tv shows to se which show is on right now. returns an TABLE with all information about
  --the tv show
  function tv_info.get_prog_allinfo(current_time)
    for k,v in pairs(decoded_tv_info.jsontv.programme) do
      if tonumber(v.start) <= current_time and tonumber(v.stop) > current_time then
       allinfo = v
      end
    end
    return allinfo
  end
  
  --Function that takes in a table with all tv information and extracts 
  --the inforamtion that is relevant and 
  --returns that information in an TABLE
  function tv_info.get_prog_relinfo(table_allinfo)
    table_relinfo = {}
    table_relinfo["name"] = table_allinfo.title.sv
    table_relinfo["start"] = table_allinfo.start  -- not converted to real date
    table_relinfo["stop"] = table_allinfo.stop    -- not converted to real date
    table_relinfo["channel"] = table_allinfo.channel
    return table_relinfo
  end
  
  -- input: index from menu, output: channel name
  -- Interprets the index from the tv channel menu. 
  -- Depending on what the current index is (what channel is chosen),
  -- this function returns the channel name
  function tv_info.get_channel_name(index)
    channel_name_array = tv_info.get_channel_list()
    channel_name = channel_name_array[index]
    return channel_name
  end
  
  -- FINAL FUNCTION THAT RUNS ON OK KEYCLICK IN MENU
  -- input: chosen channel
  -- output: name of current show, name of channel (these can be modified to retreive more information)
  function get_current_prog_info() 
    
  local channel_name = tv_info.get_channel_name(get_current_index()) 
  local current_time = tv_info.get_unixtimestamp()
  local relevant_tv_info = {}
  relevant_tv_info = tv_info.get_prog_relinfo(tv_info.get_prog_allinfo(current_time))  
  local current_prog_name = relevant_tv_info["name"]
  
return current_prog_name, channel_name
end

return tv_info
