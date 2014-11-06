-- Shall prompt the user onStart to choose the channel out of the possible channels
--local prompt = {}
--Initial values
dir = '/scrum1/static/img/'
grey1 = {90,90,90,255}
grey2 = {150,150,150,255}
grey3 = {150,150,150,150}
grey4 = {0,0,0,180}
green1 = {0, 255, 0, 255}
vertical_pos = 0
horizontal_pos = 0
start = 0
local menu

require("menu_object")

function prompt_channel(channel_list)
   --Delar upp skärmen i 3 delar på bredden, och 7 delar på höjden.
  local img1 = gfx.loadpng(dir .. 'boxIT.png')
  height = screen:get_height()
  width = screen:get_width()
  width_x = (width-100)/3
  height_y = (height-100)/7
  --Prints out the large grey box
  screen:fill(grey1, {x=50,y=50,w=width_x*3, h=height_y*7})
  screen:copyfrom(img1, nil, {x=50,y=50})
  
  menu = menu_object(width_x,height_y*4)
  add_menu_items()
  menu:set_background(dir.."tv_picture.png")
  timer = sys.new_timer(100, "update_menu")
  draw_menu()
  
  --Get the length of the channel_list dictionary
  local list_length = #channel_list
end

  function add_menu_items()
    menu:add_button("svt1",dir.."svt1.png")
    menu:add_button("svt1",dir.."svt2.png")
    menu:add_button("svt1",dir.."tv3.png")
    menu:add_button("svt1",dir.."tv4.png")
    menu:add_button("svt1",dir.."kanal5.png")
    menu:add_button("svt1",dir.."tv6.png")
end

function draw_menu()
  screen:clear() --Will clear all background stuff
  screen:copyfrom(menu:get_surface(), nil,{x=100,y=100,width=menu:get_size().width,height=menu:get_size().height},true)
  menu:destroy()
  gfx.update()
end

function increase_index()
  menu:increase_index()
end
function decrease_index()
  menu:decrease_index()
end

function update_menu()
  draw_menu()
end



  

--return prompt