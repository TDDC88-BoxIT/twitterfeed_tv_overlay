-- Shall prompt the user onStart to choose the channel out of the possible channels
--local prompt = {}
--Initial values
twitter = require("scrum1.twitter")
require("scrum1.menu_object")
require("scrum1.render_text")
dir = '/scrum1/static/img/'
grey1 = {90,90,90,255}
grey2 = {150,150,150,255}
grey3 = {150,150,150,150}
grey4 = {0,0,0,180}
green1 = {0, 255, 0, 255}
vertical_pos = 0
horizontal_pos = 0
tweet_count = 1
local menu
local corners
twitter = require("scrum1.twitter")
require("scrum1.menu_object")
require("scrum1.render_text")

--- Loads in a picture and draw that picture on the entire surface "screen"
-- @author Joel
function draw_tv_screen()
  local tv_img = gfx.loadpng(dir .. 'tv_picture.png')
  screen:copyfrom(tv_img, nil, {x=0,y=0})
  tv_img:destroy()
end

--Function that adds rounded corners to tweet-boxes
--INPUT: Starting x-coordinate & Starting y-coordinate & box_width & box_height
--@ param Start_x start_y box_width bozx_height
--@author Alexander Åquist
function add_rounded_corners(start_x,start_y,box_width,box_height)
    --Adds roundes corners
    local start_x = start_x-8 -- minus 8 to make room for corner
    local start_y = start_y-8 -- minues 8 to make room for corner
    local upper_left_corner_pos_x = start_x
    local upper_right_corner_pos_x = upper_left_corner_pos_x + box_width+8
    local upper_left_corner_pos_y = start_y
    local upper_right_corner_pos_y = upper_left_corner_pos_y
    local lower_left_corner_pos_x = start_x
    local lower_right_corner_pos_x = upper_left_corner_pos_x + box_width+8
    local lower_left_corner_pos_y = start_y + box_height
    local lower_right_corner_pos_y = lower_left_corner_pos_y+8


    if corners == nil then
     corners = gfx.loadpng('scrum1/static/img/corner_16x16_red.png')
   end

    --Creates the upper left corner
   screen:copyfrom(corners, {x=0, y=0, width=8, height=8}, {x=upper_left_corner_pos_x,y=upper_left_corner_pos_y,width=8,height=8},true)
   --Creates the upper right corner
   screen:copyfrom(corners, {x=8, y=0 , width=8, height=8}, {x=upper_right_corner_pos_x , y=upper_right_corner_pos_y , width=8 , height=8}, true)
      --Creates the lower left corner
   screen:copyfrom(corners, {x=0, y=8 , width=8, height=8}, {x=lower_left_corner_pos_x , y=lower_left_corner_pos_y , width=8 , height=8}, true)
   --Create the lower right corner
   screen:copyfrom(corners, {x=8,y=8,width=8,height=8}, {x=lower_right_corner_pos_x , y=lower_right_corner_pos_y , width=8 , height=8}, true)
    --creates the middle-top fill
   screen:fill(menu_color, {x=start_x+8, y=start_y , width=box_width, height=8})
    --creates the lower filler
   screen:fill(menu_color, {x=start_x+8 ,y=start_y+box_height+8 ,width=box_width,height=8})
   --Creates RIGHT-side filler
   screen:fill(menu_color, {x=start_x, y=start_y+8, width=8, height=box_height})
    --Creates LEFT-side filler
   screen:fill(menu_color, {x=start_x+box_width+8, y=start_y+8, width=8, height=box_height})
 end

--- Draws tweets on screen.
-- Loads in some tweets with get_tweets() from twitter.lua and then draws them on a surface using render_text.
-- @param tweets table of tweets to be shown
-- @author Claes, Jesper, Joel
function draw_tweet(tweets)
  --right view mode
  if view_mode == 0 then
    tweet_background = gfx.new_surface(400,500)
    tweet_background:clear(menu_color)
    current_tweet = tweet_count
    render_text("@" .. tweets[current_tweet].name,10,10,3500,3,tweet_background)
    render_text(tweets[current_tweet].text,10,80,350,2,tweet_background)
    render_text(tweets[current_tweet].date,10,450,350,1.5,tweet_background)
    add_rounded_corners(850,380,400,300) --Adds roundes corners
    screen:copyfrom(tweet_background,nil,{x = 850, y = 380, w = 400, h = 300},true)
    tweet_background:destroy()

    --bottom view mode
  elseif view_mode == 1 then
    tweet_background = gfx.new_surface(screen:get_width(),100)
    tweet_background:clear(menu_color)
    current_tweet = tweet_count
    render_text("@" .. tweets[current_tweet].name .. ":",5,5,3500,1.5,tweet_background)
    render_text(tweets[current_tweet].text,5,30,screen:get_width() - 5,1.5,tweet_background)
    render_text(tweets[current_tweet].date,(screen:get_width() - 260), 80,3000,1,tweet_background)
    screen:copyfrom(tweet_background,nil,{x = 0, y = screen:get_height() - 110, w = screen:get_width(), h = 100},true)
    tweet_background:destroy()
    --left view mode
  elseif view_mode == 2 then
    tweet_background = gfx.new_surface(400,500)
    tweet_background:clear(menu_color)
    current_tweet = tweet_count
    render_text("@" .. tweets[current_tweet].name .. ":",10,10,3500,3,tweet_background)
    render_text(tweets[current_tweet].text,10,80,350,2,tweet_background)
    render_text(tweets[current_tweet].date,10,450,350,1.5,tweet_background)
    add_rounded_corners(50,380,400,300) --Adds rounded corners
    screen:copyfrom(tweet_background,nil,{x = 50, y = 380, w = 400, h = 300},true)
    tweet_background:destroy()
    --top view mode
  elseif view_mode == 3 then
    tweet_background = gfx.new_surface(screen:get_width(),100)
    tweet_background:clear(menu_color)
    current_tweet = tweet_count
    render_text("@" .. tweets[current_tweet].name .. ":",5,5,3500,1.5,tweet_background)
    render_text(tweets[current_tweet].text,5,30,screen:get_width() - 5,1.5,tweet_background)
    render_text(tweets[current_tweet].date,(screen:get_width() - 260), 80,3000,1,tweet_background)
    screen:copyfrom(tweet_background,nil,{x = 0, y = 10, w = screen:get_width(), h = 100},true)
    tweet_background:destroy()
  end

  --Declaring timer_state which is instantiated in draw_menu-function as =0. First time you decide
  --to view tweets from the menu, the infobox will be shown for x seconds, depending on what is declared in sys.new_tmer below
  if timer_state == 0 then
    --local info_box_image = gfx.loadpng(dir .. 'info_box_view.png')
    --info_box = gfx.new_surface(400,105)
    info_box = gfx.new_surface(800,130)
    info_box:fill(grey4)
    --info_box:copyfrom(info_box_image, nil,nil,true)
    render_text("To see next or previous tweet press DOWN or UP. If you wish to view the tweets in a different way use RIGHT and LEFT. When you want to watch another channel press BACK.", 5, 5, 800, 1.5, info_box)
    screen:copyfrom(info_box,nil,{x = screen:get_width()/2-400, y = screen:get_height()-240},{x=100,y=100, w=400, h =200},true)
    info_box:destroy()
    --info_box_image:destroy()
    -- timer currently set to 12 seconds.
    if help_timer == nil then
      help_timer = sys.new_timer(15000, "clear_info_box")
    end
  end
  
  --This starts a timer that cycles through the tweets automatically, every 20 seconds it will go to next tweet, pressing next or previous tweet on the remote will reset the timer.
  if tweet_timer_starter == 1 then
    next_tweet_timer = sys.new_timer(20000, "next_tweet")
    tweet_timer_starter = 0
  end
  gfx.update()
end

--- Function that timer calls, changes the timer_state to 1 so that the info box is only showed once at each view-start from menu.
-- @return an integer with the timer state
-- @author Claes, Jesper
function clear_info_box()
  timer_state =1
  draw_tv_screen()
  draw_tweet(tweets)
  help_timer:stop()
  return timer_state
end

--- Draws screen and tweets.
-- Function that gets called from the OnKey, key == 'ok' and then
-- draw background and tweet using functions draw_tv_screen() and draw_tweet()
-- Every time that the user enters the render tweet view the tweet count will be reset
-- @author Claes, Joel
function render_tweet_view()
  view_mode = 1
  tweet_count = 1
  timer_state = 0
  tweet_timer_starter = 1
  draw_tv_screen()
  --get currrent channel and program
  local channel_info = retrieve_prog_info()
  tweets = twitter.get_tweets(channel_info)

  draw_tweet(tweets) 
end

--- This function will show the next tweet when in the tweet view
-- @author Claes, Gustav B-N
function next_tweet()
  --old_tweets = tweets
  if tweet_count < #tweets then
    tweet_count = tweet_count + 1
  else
    --Get new tweets...
    local channel_info = retrieve_prog_info()
    
    tweets = twitter.get_new_tweets(channel_info,tweets)

  end
  draw_tv_screen()
  draw_tweet(tweets)
end

--- This function will show the previous tweet when in the tweet view
-- @author Claes
function previous_tweet()
  if tweet_count > 1 then
    tweet_count = tweet_count - 1
    draw_tv_screen()
    draw_tweet(tweets)
  end
end

--- Swtiches to the next tweet viewing mode.
-- @author Claes
function next_view()
  if view_mode ~= nil then
    if view_mode == 3 then
      view_mode = 0
    else
      view_mode = view_mode + 1
    end
    draw_tv_screen()
    draw_tweet(tweets)
  end
end

--- Swtiches to the previous tweet viewing mode.
-- @author Claes
function previous_view()
  if view_mode ~= nil then
    if view_mode == 0 then
      view_mode = 3
    else
      view_mode = view_mode - 1
    end
    draw_tv_screen()
    draw_tweet(tweets)
  end
end

--- Function that deals with the key input when the user is in the twitter state.
-- @author Claes
function twitter_state(key,state)
  if key == 'down' and state == 'down' then
    if next_tweet_timer ~= nil then
      next_tweet_timer:stop()
      tweet_timer_starter = 1
    end
    next_tweet()
  elseif key =='up' and state == 'down' then
    if next_tweet_timer ~= nil then
      next_tweet_timer:stop()
      tweet_timer_starter = 1
    end
    previous_tweet()
  elseif key == 'menu' and state == 'down' then
    change_state(0)
    if next_tweet_timer ~= nil then
      next_tweet_timer:stop()
      tweet_timer_starter = 1
    end
    --This is to stop the help timer
    if help_timer ~= nil then
      help_timer:stop()
      help_timer = nil
    end
  elseif key == 'exit' and state == 'down' then
    sys.stop()
  elseif key == 'right' and state == 'down' then
    next_view()
  elseif key == 'left' and state == 'down' then
    previous_view()    
  else
    return
  end
end


