function prompt_channel(channel_list)

  -- Picture of the company logo
  local company_img = gfx.loadpng(dir .. 'boxIT.png')

  -- Gets the height and width of the screen
  height = screen:get_height()
  width = screen:get_width()

  -- Should not use these! 
  width_x = (width-100)/3
  height_y = (height-100)/7

  -- Prints the tv picture in the background
  draw_tv_screen()
  --local tv_img = gfx.loadpng(dir .. 'tv_picture.png')
  --screen:copyfrom(tv_img, nil, {x=0,y=0})

  -- Sets offset for the gray box to 5% of the total width and height
  local x_offset = width*0.05
  local y_offset = height*0.05
  local box_height = height*0.9
  local box_width = width*0.9

  --Prints out the large grey box and the company logo
  screen:fill(grey1, {x=x_offset,y=y_offset,w=box_width, h=box_height})
  screen:copyfrom(company_img, nil, {x=x_offset,y=y_offset})

  -- Creates a meny object and draws it
  menu_width = 600
  menu_height = 400
  menu = menu_object(menu_width,menu_height)
  add_menu_items()
  menu:set_background(dir.."menu_background.png")
  --timer = sys.new_timer(100, "update_menu") -- removed for now because no need for it in the app
  draw_menu()

  --Get the length of the channel_list dictionary
  --local list_length = #channel_list
end

  function add_menu_items()
    -- menu:add_button("svt1","SVT 1")
    -- menu:add_button("svt1","SVT 2")
    -- menu:add_button("svt1","Kanal 3")
    -- menu:add_button("svt1","TV4")
    -- menu:add_button("svt1","Kanal 5")
    -- menu:add_button("svt1","Kanal 6")
    menu:add_button("svt1",dir.."tv3.png")
    menu:add_button("svt1",dir.."tv4.png")
    menu:add_button("svt1",dir.."kanal5.png")
    menu:add_button("svt1",dir.."tv6.png")
end

function draw_menu()

  -- Do we need this following line of code?!
  --screen:clear() --Will clear all background stuff
  screen:copyfrom(menu:get_surface(), nil,{x=(width/2)-(menu_width/2),y=(height/2)-(menu_height/2),width=menu:get_size().width,height=menu:get_size().  height},true)
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
  prompt_channel(channel_list)
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
--return prompt