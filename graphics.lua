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
am_i_in_menu = 1
local menu
-- this has to be solved i another way later
local channel_list = tv_info.get_channel_list()
twitter = require("twitter")
require("scrum1.menu_object")
require("render_text")
function draw_tv_screen()
  local img2 = gfx.loadpng(dir .. 'tv_picture.png')
  screen:copyfrom(img2, nil, {x=0,y=0})
end
function draw_tweet()
  tweet_background = gfx.new_surface(400,500)
  tweet_background:clear(grey4)
  tweets = twitter.get_tweets("")
  render_text("@" .. tweets[1].name,10,10,350,5,tweet_background)
  render_text(tweets[1].text,10,80,350,2,tweet_background)
  render_text(tweets[1].date,10,400,350,2,tweet_background)
  screen:copyfrom(tweet_background,nil,{x = 850, y = 380, w = 400, h = 300},true)
end
function render_tweet_view()
  am_i_in_menu = 0
  draw_tv_screen()
  draw_tweet()
  --draw_tweet()
  
end

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
  --timer = sys.new_timer(100, "update_menu")
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
  -- Do we need this following line of code?!
  --screen:clear() --Will clear all background stuff
  screen:copyfrom(menu:get_surface(), nil,{x=(width/2)-(menu_width/2),y=(height/2)-(menu_height/2),width=menu:get_size().width,height=menu:get_size().height},true)
  menu:destroy()
  gfx.update()
end

function increase_index()
  menu:increase_index()
  if am_i_in_menu == 1 then
  update_menu()
  end
end
function decrease_index()
  menu:decrease_index()
  if am_i_in_menu == 1 then
  update_menu()
  end
end
function go_back_to_menu()
  am_i_in_menu = 1
  prompt_channel(channel_list)
end
function update_menu()
  draw_menu()
end


--return prompt