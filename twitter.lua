local twitter = {}

function twitter.authenticate()
  --Here there will be code that manages authentication with twitter
  return true
end


function twitter.get_tweets(program_name)
  
  local json = require("json")
  local decoded = {}

  --Here there will be code that sends the neccessary information to the twitter api so that tweets containing the search term 'program_name' will be returned
  
  local tweets = {}

-- This part simulates receiving tweets, it reads a json object from a file and decodes it
  local f = io.open("static/json/paradisehotelse.json","rb")
	if f then 
	  f:close() 
	end	
	if f ~= nil then
	  local lines = ""
	  for line in io.lines("static/json/paradisehotelse.json") do 
	    lines = lines .. line
	  end
    
    -- This is where the json object is decoded
    decoded_tweets = json:decode(lines)
  end
  
  local i = 1
  for k,v in pairs(decoded_tweets.statuses) do
    local date = string.sub(v.created_at, 1, 19) .. string.sub(v.created_at, 26)
    --Format timestamp
    local timestamp = set_timestamp(date);

    tweets[i] = {["name"] = v.user.screen_name, ["text"] = v.text, ["date"] = date, ["timestamp"] = timestamp}
    i = i+1
  end

  return tweets
end

--Formats the twitter date to timestamp format
function set_timestamp(date)
  --Convert abbreviated month to number
  local temp_month = {["Jan"] = 01, ["Feb"] = 02, ["Mar"] = 03, ["Apr"] = 04, ["May"] = 05, ["Jun"] = 06, ["Jul"] = 07, ["Aug"] = 08, ["Sep"] = 09, ["Oct"] = 10, ["Nov"] = 11, ["Dec"] = 12}

  local timestamp = {year = string.sub(date,21,26),
         month = temp_month[string.sub(date, 5, 7)],
           day = string.sub(date, 9, 10),
          hour = string.sub(date, 12, 13),
           min = string.sub(date, 15, 16), 
           sec = string.sub(date, 18, 19),
         isdst = false}

  return timestamp
end

--Determines if one tweet is newer/older than the other
function compare_timestamp( t1, t2 )
  --Returns the difference in seconds beween t1 and t2 (could be negative)
  os.difftime(os.time(t1), os.time(t2))
end


return twitter