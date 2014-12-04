twitter = require("twitter")
 
testtwitter = {}

--- test that checks if get_tweets() return a table
-- @param channel name and program name
-- @author Joel
function testtwitter:test_get_tweets_returntype()
  test_table = {"Kanal 5", "Grey's anatomy"}
  test_value = twitter.get_tweets(test_table)
  assertIsTable(test_value)
end

--tests if the table that get_tweets() return is of 
--corrent size
--- test if the table that get_tweets() return has the correct number of tweets in it
-- @param channel name and program name
-- @author Joel
function testtwitter:test_get_tweets_tablesize()
  test_table = {"Kanal 5", "Grey's anatomy"}
  test_value = twitter.get_tweets(test_table)
  value_size = #test_value
  expected = 15
  assertEquals(value_size, expected)
end

--- test it the content of the table that get_tweets() return is correct
-- @param channel name and program name
-- @author Joel
function testtwitter:test_get_tweets_tablecontent()
  table_type = {}
  expected = type(table_type)
  assertEquals(type(test_value[1]), expected)
end


-- Tests if the compare_timestamp returns the correct value
-- @param Two tables with date info differing by 1 second
-- @author Claes K
function testtwitter:test_compare_timestamp_returnvalue()
  local expected = 4
  local t1 = os.date("*t", 1417426731)
  local t2 = os.date("*t", 1417426732)
  local test_value = twitter.compare_timestamp(t1, t2)
  expected = -1
  assertEquals(test_value, expected)
end

-- Tests if the compare_timestamp returns the correct type
-- @param Two tables with date info differing by 1 second
-- @author Claes K
function testtwitter:test_compare_timestamp_returntype()
  local expected = 4
  local t1 = os.date("*t", 1417426731)
  local t2 = os.date("*t", 1417426732)
  local test_value = twitter.compare_timestamp(t1, t2)
  expected = -1
  assertEquals(type(test_value), type(expected))
end