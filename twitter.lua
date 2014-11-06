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
    tweets[i] = {["name"] = v.user.screen_name, ["text"] = v.text, ["date"] = string.sub(v.created_at, 1, 19) .. string.sub(v.created_at, 26)}
    i = i+1
  end
  
  return tweets
end


return twitter