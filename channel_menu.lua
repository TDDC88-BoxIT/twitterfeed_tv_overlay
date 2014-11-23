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
  y_offset = height*0.06
  box_height = height*0.8
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
    sf = gfx.new_surface(box_width,height-box_height-y_offset*2)
    sf:clear(menu_color)
    render_text(menu_title,10,10,box_width,1.2,sf)
    screen:copyfrom(sf,nil,{x=x_offset, y=y_offset, w=box_width, h=height-box_height-y_offset*2},true)
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