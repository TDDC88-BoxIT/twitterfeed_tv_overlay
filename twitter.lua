local json = require("json")

local twitter = {}

function twitter.authenticate()
  --Here there will be code that manages authentication with twitter
  return true
end


function twitter.get_tweets(program_name)
  --Here there will be code that sends the neccessary information to the twitter api so that tweets containing the search term 'program_name' will be returned
  local tweets = {}
--TO DO: decode JSON that contains the tweet information
  tweets[1] = {["name"] = "PrmMan", ["text"] = "Watching this makes me want to sleep", ["date"] = "14-09-09"}
  tweets[2] = {["name"] = "MrJamesson", ["text"] = "This TV show is the booomb!", ["date"] = "14-09-09"}
  tweets[3] = {["name"] = "garnesson", ["text"] = "I wonder if I should get more coffee", ["date"] = "14-09-08"}
  tweets[4] = {["name"] = "Smith42", ["text"] = "How can anyone even watch this?", ["date"] = "14-09-07"}
  tweets[5] = {["name"] = "Johnsson", ["text"] = "I love the main protagonist!", ["date"] = "14-09-05"}
  return tweets
end


return twitter