local http = require("socket.http")
local twitter = {}

function twitter.authenticate()
  --Here there will be code that manages authentication with twitter
  return true
end


function twitter.get_tweets(search_key)
  
  local json = require("json")
  local decoded = {}

  --Here there will be code that sends the neccessary information to the twitter api so that tweets containing the search term 'program_name' will be returned
  
  local tweets = {}

-- This part simulates receiving tweets, it reads a json object from a file and decodes it
  b, c, h = http.request("http://pumi-4.ida.liu.se/twitter/Oauth.php?q="..search_key)
  -- This is where the json object is decoded
  decoded_tweets = json:decode(b)
  
  
  local i = 1
  for k,v in pairs(decoded_tweets.statuses) do
    tweets[i] = {["name"] = v.user.screen_name, ["text"] = v.text, ["date"] = string.sub(v.created_at, 1, 19) .. string.sub(v.created_at, 26)}
    i = i+1
  end
  
  return tweets
end


return twitter