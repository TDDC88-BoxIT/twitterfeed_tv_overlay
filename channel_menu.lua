tv_info = require('scrum1.tv_info')
channel_list = tv_info.get_channel_list()

function prompt_channel()
  -- Gets the height and width of the screen
  height = screen:get_height()
  width = screen:get_width()

  -- Prints the tv picture in the background
  draw_tv_screen()
  --local tv_img = gfx.loadpng(dir .. 'tv_picture.png')
  --screen:copyfrom(tv_img, nil, {x=0,y=0})

  -- Sets offset for the gray box to 5% of the total width and height
  x_offset = width*0.02
  y_offset = height*0.05
  local box_height = height*0.9
  local box_width = width*0.2

  --Prints out the large grey box and the company logo
  screen:fill(green1, {x=x_offset,y=y_offset,w=box_width, h=box_height})
 
  -- Creates a meny object and draws it
  channel_menu = menu_object(box_width,box_height)
  add_menu_items(channel_list)
  channel_menu:set_background(dir.."menu_background.png")
  --timer = sys.new_timer(100, "update_menu") -- removed for now because no need for it in the app
  draw_menu()
end

  function add_menu_items()
  --Get the length of the channel_list dictionary
  local list_length = #channel_list
  
  for i=1,list_length,1 do
    channel_menu:add_button("svt1 hej",dir.."tv3.png")
    --channel_menu:add_button("svt1",channel_list[i])
  end
  
    -- menu:add_button("svt1","SVT 1")
    -- menu:add_button("svt1","SVT 2")
    -- menu:add_button("svt1","Kanal 3")
    -- menu:add_button("svt1","TV4")
    -- menu:add_button("svt1","Kanal 5")
    -- menu:add_button("svt1","Kanal 6")
 end

function draw_menu()
  -- Do we need this following line of code?!
  --screen:clear() --Will clear all background stuff
  screen:copyfrom(channel_menu:get_surface(), nil,{x=x_offset,y=y_offset,width=channel_menu:get_size().width,height=channel_menu:get_size().height},true)
  channel_menu:destroy()
  gfx.update()
end

function update_menu()
  draw_menu()
end

--Function that re-draws the menu, called when going back
--from viewing mode
function go_back_to_menu()
  am_i_in_menu = 1
  prompt_channel(channel_list)
end
--function that increase the index in the menu "moving up"
--and moves the red marker if it's suppose to
function increase_index()
  if am_i_in_menu == 1 then
    channel_menu:increase_index()
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
    channel_menu:decrease_index()
    update_menu()
  end
  if am_i_in_menu == 0 then
    --previous_tweet() TO BE IMPLEMENTED
  end
end
--return prompt