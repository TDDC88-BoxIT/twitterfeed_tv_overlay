twitter = require("scrum1.twitter")

-- At the moment the search string is not functional.
tweets = twitter.get_tweets("sdf")


-- Here is the example of the tweet data, it prints all the information from the first tweet received from get_tweets()
print("@" .. tweets[1].name .. ": " .. tweets[1].text .. " " .. tweets[1].date)