--package.path = package.path .. ';./Test_Twitter/?.lua;'
require("luaunit")
--package.path = package.path .. ';./Test_Twitter/?.lua;'
package.path = "Test_Twitter/?.lua;" .. package.path

require("tests.test_tv_info")
require("tests.test_graphics")
require("tests.test_twitter")

lu = LuaUnit.new()
lu:setOutputType("Junit")
os.exit( lu:runSuite() )


--os.exit(LuaUnit.run())