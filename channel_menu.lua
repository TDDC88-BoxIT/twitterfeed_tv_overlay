tv_info = require('scrum1.tv_info')
local channel_list = tv_info.get_channel_list()

function prompt_channel_menu()
  -- Gets the height and width of the screen
  height = screen:get_height()
  width = screen:get_width()

  -- Prints the tv picture in the background
  draw_tv_screen()
 
  -- Sets offset for the gray box to 5% of the total width and height
  x_offset = width*0.02
  y_offset = height*0.05
  local box_height = height*0.9
  local box_width = width*0.2

  --Prints out the large grey box and the company logo
  screen:fill(green1, {x=x_offset,y=y_offset,w=box_width, h=box_height})
 
  -- Creates a meny object and draws it
  menu = menu_object(box_width,box_height)
  add_menu_items(channel_list)
  menu:set_background(dir.."menu_background.png")
  --timer = sys.new_timer(100, "update_menu") -- removed for now because no need for it in the app
  draw_menu()
end

  function add_menu_items()
  --Get the length of the channel_list dictionary
  local list_length = #channel_list 
  for i=1,list_length,1 do
    menu:add_button(channel_list[i],channel_list[i])
--    if channel_list[i] == "SVT1" then
--        sys.stop()
--    end
  end
 end

function draw_menu()
  -- Do we need this following line of code?!
  --screen:clear() --Will clear all background stuff
  screen:copyfrom(menu:get_surface(), nil,{x=x_offset,y=y_offset,width=menu:get_size().width,height=menu:get_size().height},true)
  menu:destroy()
  gfx.update()
end

function update_menu()
  draw_menu()
end

--Function that re-draws the menu, called when going back
--from viewing mode
function go_back_to_menu()
  am_i_in_menu = 1
  prompt_channel_menu()
end
--function that increase the index in the menu "moving up"
--and moves the red marker if it's suppose to
function increase_index()
  if am_i_in_menu == 1 then
    menu:increase_index()
    update_menu()
  end
  if am_i_in_menu == 0 then
    next_tweet()
  end
end

--function that increase the index in the menu "moving down"
--and moves the red marker if it's suppose to
function decrease_index()
  if am_i_in_menu == 1 then
    menu:decrease_index()
    update_menu()
  end
  if am_i_in_menu == 0 then
    --previous_tweet() TO BE IMPLEMENTED
  end
end

-- Function that sets the chosen_channel variable in main
function setChannel()
    chosen_channel = menu:get_indexed_item().id
    if chosen_channel == "SVT1" then
      sys.stop()
    end   
end

-- Function that deals with the key input when in the menu state
function menuState(key,state)
  if key == 'down' and state == 'down' then
      increase_index()
    elseif key =='up' and state == 'down' then
      decrease_index()
    elseif key == 'ok' and state == 'down' then
--      if menu:get_indexed_item().id == "SVT2" then
--        sys.stop()
--      end
      setChannel()
      render_tweet_view()
    elseif key == 'menu' and state == 'down' then
      go_back_to_menu()   
    elseif key == 'exit' and state == 'down' then
      sys.stop()
    else
      return
    end
end