-- Shall prompt the user onStart to choose the channel out of the possible channels
local prompt = {}
--Initial values
dir = 'scrum1/static/img/'
grey1 = {90,90,90,255}
grey2 = {150,150,150,255}
grey3 = {150,150,150,150}
grey4 = {0,0,0,180}
green1 = {0, 255, 0, 255}
vertical_pos = 0
horizontal_pos = 0
start = 0

function prompt.prompt_channel()
   --Delar upp skärmen i 3 delar på bredden, och 7 delar på höjden.
  local img1 = gfx.loadpng(dir .. 'boxIT.png')
  height = screen:get_height()
  width = screen:get_width()
  width_x = (width-100)/3
  height_y = (height-100)/7
  
  
  screen:fill(grey1, {x=50,y=50,w=width_x*3, h=height_y*7})
  screen:copyfrom(img1, nil, {x=50,y=50})
  -- supposed to be the "CHOOSE CHANNEL" button
  screen:fill(grey2, {x=100+width_x,y=100+height_y*4,w=width_x,h=height_y*3/7})
  -- supposed to be the "CHANNEL LIST" of possible channels
  screen:fill(grey2, {x=100+width_x,y=100+height_y,w=width_x,h=height_y*5/2})
end

return prompt