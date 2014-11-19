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
am_i_in_menu = 1
tweet_count = 1
local menu

twitter = require("scrum1.twitter")
require("scrum1.menu_object")
require("scrum1.render_text")

--Temp function that gives an integer between 1 and 5
--so that a tweet can be randomly selected
--Remove this when using real tweets
function temp_slump_tweet()
  return math.random(1,5)
end

--Function that loads in a picture and draw that picture on the entire surface "screen"
function draw_tv_screen()
  local tv_img = gfx.loadpng(dir .. 'tv_picture.png')
  screen:copyfrom(tv_img, nil, {x=0,y=0})
end

--function that loads in some tweets with get_tweets() from twitter.lua and then draws
--them on a surface using render_text
-- In parameter are the tweets that will be shown
function draw_tweet(tweets)
  --right view mode
  if view_mode == 0 then
    tweet_background = gfx.new_surface(400,500)
    tweet_background:clear(grey4)
    current_tweet = tweet_count
    render_text("@" .. tweets[current_tweet].name,10,10,350,3,tweet_background)
    render_text(tweets[current_tweet].text,10,80,350,2,tweet_background)
    render_text(tweets[current_tweet].date,10,400,350,1.5,tweet_background)
    screen:copyfrom(tweet_background,nil,{x = 850, y = 380, w = 400, h = 300},true)
    --bottom view mode
  elseif view_mode == 1 then
    tweet_background = gfx.new_surface(screen:get_width(),100)
    tweet_background:clear(grey4)
    current_tweet = tweet_count
    render_text("@" .. tweets[current_tweet].name .. ":",5,5,60,1.5,tweet_background)
    render_text(tweets[current_tweet].text,5,30,screen:get_width() - 5,1.5,tweet_background)
    render_text(tweets[current_tweet].date,(screen:get_width() - 260), 70,3000,1,tweet_background)
    screen:copyfrom(tweet_background,nil,{x = 0, y = screen:get_height() - 110, w = screen:get_width(), h = 100},true)
    --left view mode
  elseif view_mode == 2 then
    tweet_background = gfx.new_surface(400,500)
    tweet_background:clear(grey4)
    current_tweet = tweet_count
    render_text("@" .. tweets[current_tweet].name .. ":",10,10,350,3,tweet_background)
    render_text(tweets[current_tweet].text,10,80,350,2,tweet_background)
    render_text(tweets[current_tweet].date,10,400,350,1.5,tweet_background)
    screen:copyfrom(tweet_background,nil,{x = 50, y = 380, w = 400, h = 300},true)
    --top view mode
  elseif view_mode == 3 then
    tweet_background = gfx.new_surface(screen:get_width(),100)
    tweet_background:clear(grey4)
    current_tweet = tweet_count
    render_text("@" .. tweets[current_tweet].name .. ":",5,5,60,1.5,tweet_background)
    render_text(tweets[current_tweet].text,5,30,screen:get_width() - 5,1.5,tweet_background)
    render_text(tweets[current_tweet].date,(screen:get_width() - 260), 70,3000,1,tweet_background)
    screen:copyfrom(tweet_background,nil,{x = 0, y = 10, w = screen:get_width(), h = 100},true)
  end

  --Declaring timer_state which is instantiated in draw_menu-function as =0. First time you decide
  --to view tweets from the menu, the infobox will be shown for x seconds, depending on what is declared in sys.new_tmer below
  if timer_state == 0 then
    local info_box_image = gfx.loadpng(dir .. 'info_box_view.png')
    info_box = gfx.new_surface(400,105)
    info_box:fill(grey4)
    info_box:copyfrom(info_box_image, nil,nil,true)
    screen:copyfrom(info_box,nil,{x = screen:get_width()/2-200, y = screen:get_height()-215},{x=100,y=100, w=400, h =200},true)
    -- timer currently set to 6 seconds.
    help_timer = sys.new_timer(6000, "clear_info_box")
  end
end
-- function that timer calls, changes the timer_state to 1 so that the info box is only showed once at each view-start from menu.
function clear_info_box()

  timer_state =1
  draw_tv_screen()
  draw_tweet(tweets)
  help_timer:stop()
  return timer_state
end





--Function that gets called from the OnKey, key == 'ok' and then
--draw background and tweet using functions draw_tv_screen() and draw_tweet()
--Every time that the user enters the render tweet view the tweet count will be reset
function render_tweet_view()
  view_mode = 1
  tweet_count = 1
  draw_tv_screen()
  tweets = twitter.get_tweets("")
  draw_tweet(tweets) 
end


--This function will show the next tweet when in the tweet view
function next_tweet()
  if tweet_count < #tweets then
    tweet_count = tweet_count + 1
  else
    --Get new tweets...
    tweets = twitter.get_new_tweets(tweets)
  end
  draw_tv_screen()
  draw_tweet(tweets)
end

--This function will show the previous tweet when in the tweet view
function previous_tweet()
  if tweet_count > 1 then
    tweet_count = tweet_count - 1
    draw_tv_screen()
    draw_tweet(tweets)
  end
end

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



-- Function that deals with the key input when the user is in the twitter state
function twitter_state(key,state)
  if key == 'down' and state == 'down' then
    next_tweet()
  elseif key =='up' and state == 'down' then
    previous_tweet()
  elseif key == 'menu' and state == 'down' then
    change_state(0)
    go_back_to_menu()
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
