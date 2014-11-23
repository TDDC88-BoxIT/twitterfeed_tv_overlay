--tv_info = require('scrum1.tv_info')
require("scrum1.graphics")
require("scrum1.channel_menu")
dir = 'scrum1/static/img/'
grey1 = {90,90,90,255}
grey2 = {150,150,150,255}
grey3 = {150,150,150,150}
grey4 = {0,0,0,180}
menu_color = {0,0,0,100}
green1 = {0, 255, 0, 255}
vertical_pos = 0
horizontal_pos = 0
start = 0
local chosen_channel

function onStart()
  global_tweet_state = 0
  prompt_channel_menu()
end
function draw_screen()
  --Delar upp skärmen i 3 delar på bredden, och 7 delar på höjden.
  local img1 = gfx.loadpng(dir .. 'boxIT.png')
  height = screen:get_height()
  width = screen:get_width()
  width_x = (width-100)/3
  height_y = (height-100)/7

  -- Creates a menu where you can move around with the "up", "down, "left" and "right" arrows. Select with "space".

  if start == 0 then
    screen:fill(grey1, {x=50,y=50,w=width_x*3, h=height_y*7})
    screen:copyfrom(img1, nil, {x=50,y=50})
    local j = 4.3
    if vertical_pos == 0 then
      screen:fill(green1, {x=width_x/5-4, y = height_y*j - 1,w=width_x + 4, h=height_y +2})
      local count = 1
      if horizontal_pos == 0 then
        screen:fill(green1, {x=(width_x/5)+width_x , y = height/7 - count, w = width_x*0.89, h=height_y+2})
      else 
        screen:fill(green1, {x=(width_x/5)+2*width_x , y = height/7 - count, w = width_x*0.89, h=height_y+2})
      end
      for i = 0, 1 do
        screen:fill(grey2, {x=(width_x/5)+width_x+i*width_x + count, y = height/7, w = width_x*0.88, h=height_y})
        count = count+1
      end
    elseif vertical_pos == 1 then
      screen:fill(green1, {x=width_x/5-4, y = height_y*(j+1.1) -1, w=width_x +4, h =height_y +2})
    else
      screen:fill(green1, {x=width_x/5-4, y = height_y*(j+2.2) -1, w =width_x +4, h = height_y +2})
    end
    for i = 0, 2 do
      screen:fill(grey2, {x=width_x/5-2, y=height_y*j, w=width_x, h=height_y})
      j = j+ 1.1
    end

    --To go to the "Television-overlay", stand in top left of the "left boxes", and left of the "right boxes" and press "space".

  elseif start == 1 then
    local img2 = gfx.loadpng(dir .. 'tv_picture.png')
    local tweet = gfx.loadpng(dir .. 'tweet5.png')
    screen:copyfrom(img2, nil, {x=0,y=0})
    screen:fill(grey4, {x = (width_x/5)+2*width_x, y = height_y*2, w = width_x, h = height_y*3})
    screen:copyfrom(tweet, nil, {x = (width_x/5)+2*width_x, y = height_y*2, w = width_x, h = height_y*3} ,true)
  end
end

function set_chosen_channel(channel)
  chosen_channel = channel
end

function get_chosen_channel()
  return chosen_channel
end

function change_state(state)
  global_tweet_state = state
end

function onKey(key,state)
  -- If the variable is equal to 0 this means that it is in the menu state
  if global_tweet_state == 0 then
    menu_state(key,state)
  elseif global_tweet_state == 1 then
    twitter_state(key,state)
--  else
--    if key == 'down' and state == 'down' then
--      increase_index()
--    elseif key =='up' and state == 'down' then
--      decrease_index()
--    elseif key == 'ok' and state == 'down' then
--      setChannel()
--      render_tweet_view()
--    elseif key == 'menu' and state == 'down' then
--      go_back_to_menu()   
--    elseif key == 'exit' and state == 'down' then
--      sys.stop()
--    else
--      return
--    end
  end
end 
