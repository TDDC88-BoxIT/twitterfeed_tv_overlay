require("menu_object")
require("class")
test_menu_object = {}

--- test that checks if set_size() set the correct value on the correct variable
-- @author Joel
function test_menu_object:test_set_size_width()
  width = 100
  height = 150
  menu_object:set_size(width,height)
  expected = 100
  assertEquals(menu_object.width, expected)
end

--- test that checks if set_size() set the correct value on the correct variable
-- @author Joel
function test_menu_object:test_set_size_height()
  width = 100
  height = 150
  menu_object:set_size(width,height)
  expected = 150
  assertEquals(menu_object.height, expected)
end

--- test that checks if get_size() returns the correct value
-- @author Joel
function test_menu_object:test_get_size_value()
  width = 100
  expected_width = 100
  height = 150
  expected_height = 150
  menu_object:set_size(width,height)
  test_value = menu_object:get_size()
  assertEquals(test_value.height, expected_height)
  assertEquals(test_value.width, expected_width)
end

--- test that checks if set_button_size() gives the correct values to the button
-- @author Joel
function test_menu_object:test_set_button_size()
width = 15
height = 12
expected_width = 15
expected_height = 12
menu_object:set_button_size(width, height)
assertEquals(menu_object.button_width, expected_width)
assertEquals(menu_object.button_height, expected_height)
end

--- test that checks if get_button_size() returns the correct values
-- @author Joel
function test_menu_object:test_get_button_size_value()
  width = 20
  height = 30
  expected_width = 20
  expected_height = 30
  menu_object:set_button_size(width,height)
  test_value = menu_object:get_button_size()
  assertEquals(test_value.height, expected_height)
  assertEquals(test_value.width, expected_width)
end

--- test that checks if set_button_location() gives right coordinates for the buttons x and y position
-- @author Joel
function test_menu_object:test_set_button_location()
  x_pos = 10
  y_pos = 15
  expected_x = 10
  expected_y = 15
  menu_object:set_button_location(x_pos,y_pos)
  assertEquals(menu_object.button_x, expected_x)
    assertEquals(menu_object.button_y, expected_y)
end

--- test that checks if get_button_location() returns the right coordinates for the buttons x and y position
-- @author Joel
function test_menu_object:test_get_button_location()
  x_pos = 10
  y_pos = 15
  expected_x = 10
  expected_y = 15
  menu_object:set_button_location(x_pos,y_pos)
  test_table = menu_object:get_button_location()
  assertEquals(test_table.x, expected_x)
    assertEquals(test_table.y, expected_y)
end




