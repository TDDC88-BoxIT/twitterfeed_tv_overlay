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
  tweet_background = gfx.new_surface(400,500)
  tweet_background:clear(grey4)
  current_tweet = tweet_count
  render_text("@" .. tweets[current_tweet].name,10,10,350,3,tweet_background)
  render_text(tweets[current_tweet].text,10,80,350,2,tweet_background)
  render_text(tweets[current_tweet].date,10,400,350,1.5,tweet_background)
  screen:copyfrom(tweet_background,nil,{x = 850, y = 380, w = 400, h = 300},true)
  --Declaring timer_state which is instantiated in draw_menu-function as =0. First time you decide
  --to view tweets from the menu, the infobox will be shown for x seconds, depending on what is declared in sys.new_tmer below
  if timer_state == 0 then
    local info_box_image = gfx.loadpng(dir .. 'info_box_view.png')
    info_box = gfx.new_surface(400,105)
    info_box:fill(grey4)
    info_box:copyfrom(info_box_image, nil,nil,true)
    screen:copyfrom(info_box,nil,{x = 850, y = 275},{x=100,y=100, w=400, h =200},true)
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
  am_i_in_menu = 0
  
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
end
