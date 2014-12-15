--package.path = package.path .. ';./Test_Twitter/?.lua;'
require("luaunit")
--package.path = package.path .. ';./Test_Twitter/?.lua;'
package.path = package.path .. ";../?.lua"
require("tests.test_menu_object")
require("tests.test_tv_info")
require("tests.test_graphics")
require("tests.test_twitter")

lu = LuaUnit.new()
lu:setOutputType("Junit")
lu:setFname("local_testreport")
os.exit(lu:runSuite())