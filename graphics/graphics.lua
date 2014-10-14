dir = 'graphics/'
grey1 = {90,90,90,255}
grey2 = {150,150,150,255}
grey3 = {150,150,150,150}
green1 = {0, 255, 0, 255}
vertical_pos = 0
horizontal_pos = 0
start = 0

function onStart()
  draw_screen()
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
    screen:copyfrom(img2, nil, {x=0,y=0})
    screen:fill(grey3, {x = (width_x/5)+2*width_x, y = height_y*2, w = width_x, h = height_y*5})
  end
end
function onKey(key,state)
  if key == 'down'and state == 'down' and vertical_pos<2 then
    vertical_pos = vertical_pos+1
  elseif key =='up' and state=='down' and vertical_pos>0 then
    vertical_pos = vertical_pos-1
  elseif key == 'right' and state == 'down' and horizontal_pos < 2 then
    horizontal_pos = horizontal_pos + 1
  elseif key == 'left' and state == 'down' and horizontal_pos >0 then
    horizontal_pos = horizontal_pos - 1
  elseif key == 'ok' and state == 'down' and vertical_pos == 0 and horizontal_pos == 0 then
    start = 1
  elseif key == 'menu' and state == 'down' and start == 1 then -- press leftshift to go back to menu
    start = 0
  elseif key == 'exit' and state == 'down' then -- press x to exit the application
    sys.stop()
  else 
    return
  end
  draw_screen()
end  
