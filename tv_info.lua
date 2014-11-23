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
-- will be removed when we get ip-connection. input: chosen_channel_index
function tv_info.set_decoded_tv_info(ch_index)  
  local folder_path = 'static/json/'
  local curr_index = ch_index
  local path_ending = '.js'
  local channel_file_path_list = tv_info.get_channel_file_path_list()     
  local decode_path =  folder_path .. channel_file_path_list[ch_index] .. path_ending
  print('decode path: ', decode_path)
  -- open and read file
  local f = io.open(decode_path,"rb")
  print("f:")
  print(f)
  if f then 
    f:close() 
    print("error1")
  end	
  if f ~= nil then
    local lines = ""
    for line in io.lines(decode_path) do 
      lines = lines .. line
      --print("error2")
    end  
    -- This is where the json object is decoded
    print("error3")
    local decoded_tv_info = json:decode(lines)
    print("error4")
    return decoded_tv_info
  end
  print("error5")
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
function tv_info.get_prog_allinfo(current_time, ch_index)
  local channel_index = ch_index
  print('allinfo index: ', ch_index)
  local decoded_info = tv_info.set_decoded_tv_info(channel_index)
  print("decoded info: ", decoded_info)
  for k,v in pairs(decoded_info.jsontv.programme) do
    print("times")
    print(v.start)
    print(current_time)
    
    --ersätt 1415661900 med current_time
    
    if tonumber(v.start) <= current_time and tonumber(v.stop) > current_time then
      allinfo = v
      print("NU VAR DET FART")
    end
  end
  return allinfo
end

--- Extracts relevant TV information from a table.
-- @param table_allinfo a table with all TV information.
-- @return a table with relevant TV information.
-- @author Joel
function tv_info.get_prog_relinfo(table_allinfo)
  --print(table_allinfo)
  table_relinfo = {}
  table_relinfo["name"] = table_allinfo.title.sv
  table_relinfo["start"] = table_allinfo.start  -- not converted to real date
  table_relinfo["stop"] = table_allinfo.stop    -- not converted to real date
  return table_relinfo
end

-- FINAL FUNCTION THAT RUNS ON OK KEYCLICK IN MENU
-- input: chosen channel
-- output: name of current show, name of channel (these can be modified to retreive more information)
function get_current_prog_info(channel_name, ch_index)
  --local current_time = 1415579400
  local channel_list = tv_info.get_channel_list()
  local channel_index = ch_index
  local current_channel_name = channel_list[channel_index]
  print('channel index!: ', channel_index)
  local current_time = tv_info.get_unixtimestamp()
  local relevant_tv_info = {}

  relevant_tv_info = tv_info.get_prog_allinfo(current_time, channel_index)
  print("rel tv inf")
  print(relevant_tv_info)
  relevant_tv_info = tv_info.get_prog_relinfo(tv_info.get_prog_allinfo(current_time, channel_index))  
  current_prog_info = {relevant_tv_info["name"], current_channel_name}

  return current_prog_info
end

--function that will be used before get tweets to get prog info
function retrieve_prog_info()
  return current_prog_info
end

-- function that downloads schedules from xmltv. will be done on gustavs server instead...
function get_xmltv_info() 

--local http = require "socket.http"
--local body,c,l,h = 
  --http.request([[http://json.xmltv.se/svt1.svt.se_2014-11-21.js.gz]])
  -- print('body', body)

  http = require"socket.http"
  print(http.request"http://json.xmltv.se/svt1.svt.se_2014-11-21.js.gz")

end

-- ANVÄND DENNA GUSTAV
-- returns a table with internet paths for downloading the current day tv schedule for each channel
function tv_info.get_download_path_table()
  path_base = 'http://json.xmltv.se/'
  curr_date = os.date("_%Y-%m-%d")
  path_ending = '.js.gz'
  file_paths = tv_info.get_channel_file_path_list()
  path_table = {}
  for channelCount = 1, #file_paths do
    path_table[channelCount] = path_base..file_paths[channelCount]..curr_date..path_ending 
  end 
  return path_table
end

-- returns json file paths for channels 1-11.
-- paths are also used in function get_download_path_table() 
function tv_info.get_channel_file_path_list()
  local channel_file_paths = {}
  channel_file_paths[1] = 'svt1.svt.se'
  channel_file_paths[2] = 'svt2.svt.se'
  channel_file_paths[3] = 'tv3.se'
  channel_file_paths[4] = 'tv4.se'
  channel_file_paths[5] = 'kanal5.se'
  channel_file_paths[6] = 'tv6.se'
  channel_file_paths[7] = 'sjuan.se'
  channel_file_paths[8] = 'tv8.se'
  channel_file_paths[9] = 'kanal9.se'
  channel_file_paths[10] = 'tv10.se'
  channel_file_paths[11] = 'tv11.sbstv.se'
  return channel_file_paths
end

return tv_info
