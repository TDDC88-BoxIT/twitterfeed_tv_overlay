--package.path = package.path .. ';./Test_Twitter/?.lua;'
require("luaunit")
--package.path = package.path .. ';./Test_Twitter/?.lua;'
package.path = "Test_Twitter/?.lua;" .. package.path

require("tests.test_tv_info")
require("tests.test_graphics")
require("tests.test_twitter")
os.exit(LuaUnit.run())