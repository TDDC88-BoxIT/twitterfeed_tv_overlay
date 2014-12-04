-----------------------
-- menu_object class --
-----------------------

--[[
IN ORDER TO USE THE MENU OBJECT YOU FIRST NEED TO CREATE AND SAVE A NEW INSTANCE OF THE OBJECT.
THIS IS DONE BY CALLING: 
  
  menu_object_variable = menu_object(width,height,character_image_path)

IN ORDER TO DRAW THE MENU ON THE SCREEN, THE OBJECT SURFACE FIRST HAS TO BE RETRIEVED.
THIS IS DONE BY CALLING:

  menu_image_surface = menu_object_variable:get_surface()

THE MENU OBJECT HAS A SET OF CONFIGURATION FUNCTIONS WHICH CAN BE USED, THESE ARE:
  
  menu_object:set_size(menu_width,menu_height)
  menu_object:get_size()
  menu_object:set_button_size(width,height)
  menu_object:get_button_size()
  menu_object:set_button_location(button_x, button_y)
  menu_object:get_button_location()
  menu_object:add_button(button_id, img_Path)
  menu_object:clear_buttons()
  menu_object:clear_images()
  menu_object:get_indexed_item()
  menu_object:set_indicator_color(color)
  menu_object:set_indicator_width(width)
  menu_object:increase_index()
  menu_object:decrease_index()
  menu_object:get_current_index()
  menu_object:set_background(path)

MAKE SURE TO USE THE DESTROY COMMAND WHEN THE OBJECT HAS BEEN DRAWN ON SCREEN IN ORDER TO SAVE RAM!
THIS WILL DESTROY THE OBJECTS SURFACE.
THIS IS DONE BY CALLING:

  menu_object:destroy()

  --]]
  require("render_text")
  require("channel_menu")

  local corners = nil
-- THE MENU CONSTRUCTOR SETS START VALUES FOR THE MENU
menu_object = class(function (self, menu_width, menu_height)
  self.width = menu_width or math.floor(screen:get_width()*0.2)
  self.height = menu_height or 300
  self.button_height = 60
  self.button_width = math.floor(self.width*0.9)
  self.button_x = (self.width-self.button_width)/2
  self.button_y = math.floor(self.height*0.05)
  self.indicator_color = {255,255,255,150}
  self.indexed_item=1
  self.menu_items={}
  self.menu_surface=nil
  end)

-- SETS MENU SIZE
function menu_object:set_size(menu_width,menu_height)
  self.width=menu_width or self.width
  self.height=menu_height or self.height
end

-- RETURNS MENU SIZE
function menu_object:get_size()
  local size={width=self.width, height=self.height}
  return size
end

-- SETS MENU button SIZE
function menu_object:set_button_size(width,height)
  self.button_width=width or self.button_width
  self.button_height=height or self.button_height
end

-- RETURNS MENU button SIZE
function menu_object:get_button_size()
  local size={width=self.button_width, height=self.button_height}
  return size
end

-- SETS button LOCATION
function menu_object:set_button_location(button_x, button_y)
  self.button_x=button_x or menu_object:get_location().x
  self.button_y=button_y or menu_object:get_location().y
end

-- RETURNS button LOCATION
function menu_object:get_button_location()
  local location={x=self.button_x, y=self.button_y}
  return location
end

-- ADDS NEW MENU ITEMS
function menu_object:add_button(button_id, text)
  table.insert(self.menu_items, #self.menu_items+1, {id=button_id, text=text})
end

-- CLEARS ALL ADDED MENU ITEMS
function menu_object:clear_buttons()
  self.menu_items={}
end

-- RETURNS THE MENU ITEM CURRENTLY INDEXED
function menu_object:get_indexed_item()
  return self.menu_items[self.indexed_item]
end 

-- SETS THE MENU INDICATOR COLOR
function menu_object:set_indicator_color(color)
  self.indicator_color=color;
end

-- SETS THE INDICATOR WIDTH
function menu_object:set_indicator_width(width)
  self.indicator_width=width
end

-- INCREASES THE INDEX FOR CURRENTLY SELECTED MENU ITEM
function menu_object:increase_index()
  if self.indexed_item<#self.menu_items then
    self.indexed_item=self.indexed_item+1
  end
end

-- DE CREASES THE INDEX FOR CURRENTLY SELECTED MENU ITEM
function menu_object:decrease_index()
  if self.indexed_item>1 then
    self.indexed_item=self.indexed_item-1
  end
end

-- RETURNS THE INDEX OF THE CURRENTLY SELECTED MENU ITEM
function menu_object:get_current_index()
  return self.indexed_item
end

-- SETS THE INDEX OF THE CURRENTLY SELECTED MENU ITEM TO A GIVEN NUMBER
function menu_object:set_current_index(index)
  self.indexed_item = index
end

-- SETS THE PATH TO THE MENU BACKGROUND IMAGE
function menu_object:set_background(path)
  self.menu_background=path
end

-- CREATES THE MENU BACKGROUND AND ADDS IT TO THE MENU
local function make_bakground(self)
   -- local img_surface=nil
   --  img_surface = gfx.loadpng(self.menu_background)
   --  self.menu_surface:copyfrom(img_surface,nil,{x=0,y=0,width=self.width,height=self.height},true)
   --  img_surface:destroy()

   if corners == nil then
     corners = gfx.loadpng('scrum1/static/img/corner_16x16_red.png')
   end
   
   local start_x = 0
   local start_y = 0
   local size = {width=self.width, height=self.height}
   local menu_width = size.width-8 -- (-8) In order to leave room for the picutre to exist
   local menu_height = size.height-8 -- (-8) In order to leave room for the picture to exist
   local upper_left_corner_pos_x = start_x
   local upper_left_corner_pos_y = start_y
   local upper_right_corner_pos_x = start_x + menu_width
   local upper_right_corner_pos_y = start_y
   local lower_left_corner_pos_x = start_x
   local lower_left_corner_pos_y = start_y + menu_height
   local lower_right_corner_pos_x = start_x + menu_width
   local lower_right_corner_pos_y = start_y + menu_height


  --CREATING THE CORNERSTONES AND FILLS THE MENU.
   --Creates the upper left corner
   self.menu_surface:copyfrom(corners, {x=0, y=0, width=8, height=8}, {x=upper_left_corner_pos_x,y=upper_left_corner_pos_y,width=8,height=8},true)
   --Creates the upper right corner
   self.menu_surface:copyfrom(corners, {x=8, y=0 , width=8, height=8}, {x=upper_right_corner_pos_x , y=upper_right_corner_pos_y , width=8 , height=8}, true)
   --creates the middle-top fill
   self.menu_surface:fill(menu_color, {x=start_x+8, y=start_y , width=menu_width-8, height=8})
   --creates the middle-large-fill
   self.menu_surface:fill(menu_color, {x=start_x, y=start_y + 8, width=menu_width+8, height=menu_height-8})
   --Creates the lower left corner
   self.menu_surface:copyfrom(corners, {x=0, y=8 , width=8, height=8}, {x=lower_left_corner_pos_x , y=lower_left_corner_pos_y , width=8 , height=8}, true)
   --Create the lower right corner
   self.menu_surface:copyfrom(corners, {x=8,y=8,width=8,height=8}, {x=lower_right_corner_pos_x , y=lower_right_corner_pos_y , width=8 , height=8}, true)
   --creates the lower filler
   self.menu_surface:fill(menu_color, {x=start_x+8 ,y=start_y+menu_height,width=menu_width-8,height=8})  
 end

-- CREATES THE MENU INDICATOR AND ADDS IT TO THE MENU. THE Y-VALUE MARKS WHERE THE INDICATOR IS TO BE PUT
local function make_item_indicator(self, y_value)
  -- Set indicator size
  self.indicator_height = self.button_height/2 -- INDICATOR HEIGHT IS SET TO button HEIGHT
  self.indicator_width = self.button_width*0.1 -- INDICATOR WIDTH IS SET TO 10% OF button WIDTH
  -- Create indicator surface
  local sf = gfx.new_surface(self.indicator_width, self.indicator_height)
  --Set color for indicator surface
  sf:fill(self.indicator_color)
  self.menu_surface:copyfrom(sf,nil,{x=self.button_x, y=y_value, width=self.indicator_width, height=self.indicator_height})
  sf:destroy()
end

-- CREATES ALL MENU BUTTONS AND ADDS THEM TO THE MENU
local function make_buttons(self)
  -- LOOPS THROUGH ALL ITEMS WHICH HAVE BEEN ADDE TO THE MENU AND CREATES A SET OF BUTTONS FOR THESE
  for i = 1, #self.menu_items, 1 do
    render_text(self.menu_items[i].text, self.button_x +25,self.button_y+(self.button_height*(i-1)+i*10),self.button_width, 2, self.menu_surface)
    -- SETS THE BUTTON IMAGE
--     local img_surface=nil
--     img_surface = gfx.loadpng(self.menu_items[i].img)

--     -- PUTS THE CREATED BUTTON IMAGE ON THE MENU SURFACE
--     self.menu_surface:copyfrom(img_surface,nil,{x=self.button_x,y=(self.button_y+(self.button_height*(i-1)+i*10)
-- ),width=self.button_width,height=self.button_height},true)

if i == self.indexed_item then
      -- CREATES AN INDICATOR WHICH IS SET ON THE INDEXED BUTTON
      make_item_indicator(self, (self.button_y+(self.button_height*(i-1)+i*10)))
    end
--     -- DESTROYS THE BUTTON IMAGE SURFACE TO SAVE RAM CONSUMPTION
--     img_surface:destroy()
end
end

-- ASSEMBLES ALL MENU PARTS INTO A MENU
local function update(self)
  if self.menu_surface == nil then
    self.menu_surface=gfx.new_surface(self.width, self.height)
  else
    self.menu_surface:clear()
  end
  if self.height<#self.menu_items*(self.button_height+20) then
    self:set_button_size(nil,(self.height-(#self.menu_items)*20)/#self.menu_items)
  end
  make_bakground(self)
  make_buttons(self)
end

-- RETURNS THE MENU SURFACE
function menu_object:get_surface()
  update(self)
  return self.menu_surface
end 

-- DESTROYS THE MENU OBEJCT'S SURFACE
function menu_object:destroy()
  self.menu_surface:destroy()
  self.menu_surface=nil
end