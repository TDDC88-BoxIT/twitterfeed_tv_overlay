--Graphics require menu_object but that can not be tested without building a stub for menu_object
--therefore this file will test the functions in graphics not using menu_object
graphics = require("graphics")
testgraphics = {}

--tests if the temp_slump_tweet() returns a number 
function testgraphics:test_temp_slump_tweet_returntype()
  value = graphics.temp_slump_tweet()
  assertIsNumber(value)
end
