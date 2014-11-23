tv_info = require('scrum1.tv_info')
local channel_list = tv_info.get_channel_list()
menu_title = "What channel are you watching?"

--- Creates and draws the channel menu.
-- @author Sofie
function prompt_channel_menu()
  -- Gets the height and width of the screen
  height = screen:get_height()
  width = screen:get_width()

  -- Sets offset and size for the box with the channel list
  x_offset = width*0.02
  y_offset = height*0.16
  box_height = height*0.6
  box_width = width*0.2
  
  -- Chooses what index in the channel_list that should be displayed first in the menu
  channel_list_index = 1

  draw_tv_screen()
  
  -- Creates a menu object and draws it
  menu = menu_object(box_width,box_height)
  add_menu_items(channel_list_index)
  --menu:set_background(dir.."menu_background.png") <<<DONT THINK THIS IS USEFUL ANYMORE>>>
  draw_menu()
  set_menu_title()
end

-- Sets the text displayed over the menu
-- @author Sofie
function set_menu_title()
    local title_width = box_width - 16 -- In order to make place for corners
    local title_height = height-box_height-y_offset*2 - 16 -- In order to make place for corners
    local upper_left_corner_pos_x = x_offset
    local upper_right_corner_pos_x = upper_left_corner_pos_x + box_width - 8
    local upper_left_corner_pos_y = y_offset
    local upper_right_corner_pos_y = upper_left_corner_pos_y
    local lower_left_corner_pos_x = x_offset
    local lower_right_corner_pos_x = upper_left_corner_pos_x + box_width - 8
    local lower_left_corner_pos_y = y_offset + title_height + 8
    local lower_right_corner_pos_y = lower_left_corner_pos_y
    local start_x = x_offset
    local start_y = y_offset
     
    if corners == nil then
     corners = gfx.loadpng('scrum1/static/img/corner_16x16_red.png')
   end


   sf = gfx.new_surface(title_width, title_height)
   sf:clear(menu_color)
   render_text(menu_title,10,10,title_width,1.0,sf)

    --Creates the upper left corner
   screen:copyfrom(corners, {x=0, y=0, width=8, height=8}, {x=upper_left_corner_pos_x,y=upper_left_corner_pos_y,width=8,height=8},true)
   --Creates the upper right corner
   screen:copyfrom(corners, {x=8, y=0 , width=8, height=8}, {x=upper_right_corner_pos_x , y=upper_right_corner_pos_y , width=8 , height=8}, true)
    --creates the middle-top fill
   screen:fill(menu_color, {x=start_x+8, y=start_y , width=title_width, height=8})
   --Creates the lower left corner
   screen:copyfrom(corners, {x=0, y=8 , width=8, height=8}, {x=lower_left_corner_pos_x , y=lower_left_corner_pos_y , width=8 , height=8}, true)
   --Create the lower right corner
   screen:copyfrom(corners, {x=8,y=8,width=8,height=8}, {x=lower_right_corner_pos_x , y=lower_right_corner_pos_y , width=8 , height=8}, true)
    --creates the lower filler
   screen:fill(menu_color, {x=start_x+8 ,y=start_y+title_height+8 ,width=title_width,height=8})
   --Creates RIGHT-side filler
   screen:fill(menu_color, {x=start_x, y=start_y+8, width=8, height=title_height})
    --Creates LEFT-side filler
   screen:fill(menu_color, {x=start_x+title_width+8, y=start_y+8, width=8, height=title_height})
   --Copies surface to get the rendered text
   screen:copyfrom(sf,nil,{x=x_offset+8, y=y_offset+8, w=title_width, h=title_height},true)

   sf:destroy()
 end

-- Add items to the channel menu based on the channel list containing all available channels. The start_index
-- indicates what index in the channel list that should be the first button.
-- @author Sofie
function add_menu_items(start_index)
  --This should be changed once we got the new design in place  <--------------------------------------------------
  number_of_channels_shown = 6
  for i=start_index,math.min(#channel_list,start_index+number_of_channels_shown-1),1 do
    menu:add_button(channel_list[i],channel_list[i])
  end
end

--- Function that draws the channel menu.
-- @author Sofie, Jesper
function draw_menu()
  timer_state = 0
  screen:copyfrom(menu:get_surface(), nil,{x=x_offset,y=y_offset+(height-box_height-y_offset*2),width=menu:get_size().width,height=menu:get_size().height},true)
  menu:destroy()
  gfx.update()
end

--- Function that increase the index in the menu "moving up" and moves the red marker if it's supposed to.
-- @author Sofie
function increase_index()
  if menu:get_current_index()%number_of_channels_shown == 0 and channel_list_index ~= #channel_list then
    menu:clear_buttons()
    add_menu_items(channel_list_index+1)
    menu:set_current_index(1)
  else
    menu:increase_index()
  end
  draw_menu()
  if channel_list_index < #channel_list then
    channel_list_index = channel_list_index + 1
  end
end

--- Function that increase the index in the menu "moving down" and moves the red marker if it's supposed to.
-- @auhtor Sofie
function decrease_index()
  if menu:get_current_index() == 1 and channel_list_index ~= 1 then
    menu:clear_buttons()
    add_menu_items(channel_list_index-number_of_channels_shown)
    menu:set_current_index(number_of_channels_shown)
  else
    menu:decrease_index()
  end
  draw_menu()
  if channel_list_index >= 2 then
    channel_list_index = channel_list_index - 1
  end
end

-- Function that updates the menu by clearing the screen, drawing the background and setting the title of the menu
-- @author Sofie
function update_menu()
  screen:clear()
  draw_tv_screen()
  set_menu_title(menu_title)
end

--- Function that deals with the key input when the user is in the menu state.
-- @author Sofie, Claes
function menu_state(key,state)
  if key == 'down' and state == 'down' then
    --clear() and draw_tv_screen() added so that the menu is cleared and the tv screen is redrawn
    --after each navigation move
    update_menu()
    increase_index()
    elseif key =='up' and state == 'down' then
    --clear() and draw_tv_screen() added so that the menu is cleared and the tv screen is redrawn
    --after each navigation move
    update_menu()
    decrease_index()
    elseif key == 'ok' and state == 'down' then
      set_chosen_channel(menu:get_indexed_item().id)
      change_state(1)
      render_tweet_view() 
      elseif key == 'exit' and state == 'down' then
        sys.stop()
      else
        return
      end
    end
