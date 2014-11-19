twitter = require("twitter")
 
 --Function that makes it possible to get the size of the table
 function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end
  
testtwitter = {}

--tests if the get_tweets() terutn a table
function testtwitter:test_get_tweets_returntype()
  value = twitter.get_tweets("")
  assertIsTable(value)
end

--tests if the table that get_tweets() return is of 
--corrent size
function testtwitter:test_get_tweets_tablesize()
  value = twitter.get_tweets("")
  value_size = tablelength(value)
  expected = 5
  assertEquals(value_size, expected)
end

--tests if the contenct of the table that get_tweets()
--return is correct
function testtwitter:test_get_tweets_tablecontent()
  value = twitter.get_tweets("")
  table = {}
  expected = type(table)
  assertEquals(type(value[1]), expected)
end
