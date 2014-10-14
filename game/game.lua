-- STB DOMINATION
--
--  A demo game written by Anders Petersson
--  requires Zenterio OS Lua API
--  Copyright (c) 2014 Zenterio AB
--
--  Gameplay: Press number 1 through 8 to deploy the software package
--  to the corresponding item that scrolls by on the screen. Deploying
--  to a STB gives one point. Deploying to other devices costs one
--  life. The game accelerates with higher score. Game is over when the
--  lives are depleted.
--
--  Features: Timer to update the screen. Extracts digits from a
--  composite bitmap. Scales images. The background slowly changes
--  color. The items feature transparency.


-- Remove old timer if the game was already running when re-loading
-- the file
if timer then
   timer:stop()
   timer = nil
end

-- Directory of artwork 
dir = 'game/'

lanes = 8
status_height = 80
lane_height = math.floor((screen:get_height() - status_height) / lanes)
number_width = 51
number_height = 75

function scale_down(img, max_height)
   local scale = max_height / img:get_height()
   local img2 = gfx.new_surface(img:get_width() * scale,
                                max_height)
   img2:clear()
   img2:copyfrom(img, {x=0,y=0, w=img:get_width(),h=img:get_height()},
                 {x=0, y=0, w=img:get_width() * scale, h=max_height})
   return img2
end

all_image_names = {stb1 = 'stbs/315288_800390_ip4_detail.png',
                   stb2 = 'stbs/34165117_OVR_1-400px.png',
                   stb3 = 'stbs/TF100CMini-1-400px.png',
                   stb4 = 'stbs/vip-1910-9.png',
                   fake1 = 'iphone.png',
                   fake2 = 'magic_mouse-h80px.png',
                   fake3 = 'Power_Supply_80px.png',
                   fake4 = 'portal_aplabs_mug.png',
                   fake5 = 'MotorolaPhoton.png',
                   fake6 = 'prod_3051_18628-main.png',
                   fake7 = 'Volkswagen-Passat-2013-160px.png',
                   fake8 = 'kiwi-transparent.png',
                   cogs = 'sss.jpg',
                   square_logo = 'zenterio-square-logo.jpeg'}
--if not all_images then
   all_images = {}
   local max_height = lane_height - 2
   for key, path in pairs(all_image_names) do
      path = dir .. path
      local img
      if path:match('%.png$') then
         img = gfx.loadpng(path)
      elseif path:match('%.jpe?g$') then
         img = gfx.loadjpeg(path)
      end
      local new_height
      if key == 'square_logo' then
         new_height = lane_height * 2 / 3
      else
         new_height = max_height
      end
      if img:get_height() > new_height then
         img2 = scale_down(img, new_height)
         img:destroy()
         img = img2
      end
      if img then
         img:premultiply()
         all_images[key] = img
      end
   end
--end

heart = gfx.loadpng(dir..'red-heart-64px.png')

----------------------------------------------------------------------


function onStart()
   score = 0
   lives = 3
   stb_speed = 350
   z_speed = 600
   stb_interval = 4
   -- List of devices.
   -- A device is table with surface, x, y, delta_x, delta_y, ...
   devices = {}

   time_since_arm = 0
   last_add_time = 0

   timer = sys.new_timer(20, "update_cb")

   draw_screen()
end

function get_lane_y(lane)
   return status_height + (lane - 1) * lane_height
end

function make_numbers()
   local all_numbers = gfx.loadpng(dir .. '0123456789_1280px.png')
   local numbers = {}
   for i = 0, 9 do
      num = gfx.new_surface(number_width, number_height)
      num:copyfrom(all_numbers, {x=16+128*i, y=0, w=102, h=150},
                   {x=0, y=0, w=number_width, h=number_height})
      numbers[i] = num
   end
   all_numbers:destroy()
   return numbers
end
numbers = numbers or make_numbers()

function draw_number(x, y, num, digits)
   if digits == 0 then return end
   local digit = math.floor((num / 10^(digits-1)))
   screen:copyfrom(numbers[digit], nil, {x=x,y=y})
   draw_number(x + number_width * 1.1, y, num - digit * 10^(digits-1), digits - 1)
end

bg = 0
function draw_screen()
   screen:clear({g=160 + 50*math.sin(bg/300)})
   bg = bg + 1
   for key, device in pairs(devices) do
      screen:copyfrom(device.surface, nil, {x=device.x, y=device.y}, true)
   end
   draw_number(500, 10, score, 5)
   for lane = 1, lanes do
      draw_number(10, get_lane_y(lane), lane, 1)
   end

   for i = 1, lives do
      screen:copyfrom(heart, nil, {x= (heart:get_width()+4)*i, y=10}, true)
   end

   gfx.update()
end

function intersects(device1, device2)
   function overlaps(left1, right1, left2, right2)
      if left1 <= left2 and right1 >= left2 then
         return true
      elseif left1 <= right2 and right1 >= right2 then
         return true
      elseif left1 >= left2 and right1 <= right2 then
         return true
      end
      return false
   end
   
   return overlaps(device1.x, device1.x + device1.surface:get_width(),
                   device2.x, device2.x + device2.surface:get_width()) and
      overlaps(device1.y, device1.y + device1.surface:get_height(),
               device2.y, device2.y + device2.surface:get_height())
end

function update_state(delta)
   for key, device in pairs(devices) do
      if device == nil then
         print ("Device " .. key .. " is nil")
         goto continue
      end
      device.x = device.x + device.delta_x * delta
      device.y = device.y + device.delta_y * delta

      if device.delta_y > 0 then
         if device.y >= screen:get_height() - 1 then
            devices[key] = nil
            goto continue
         end
      end
      if device.delta_x < 0 then
         -- Check left border
         if device.x <= 150 then
            devices[key] = nil
            goto continue
         end
      elseif device.delta_x > 0 then
         if device.x >= screen:get_width() - 1 then
            devices[key] = nil
            goto continue
         end

         if tostring(key):match("^z") then
            -- Check collision
            for key2, device2 in pairs(devices) do
               if device2 == nil or device2.delta_x >= 0 then
                  goto continue2
               end
               if intersects(device, device2) then
                  devices[key] = nil  -- Remove this object
                  devices[key2] = nil
                  devices[#devices + 1] = device2
                  if device2.fake then
                     device2.delta_x = stb_speed / 2
                     device2.delta_y = stb_speed / 10
                     lives = lives - 1
                     if lives <= 0 then
                        return
                     end

                  else
                     device2.delta_x = 0
                     device2.delta_y = stb_speed * 1.3
                     score = score + 1  -- Score!
                     if score % 6 == 0 then
                        stb_speed = stb_speed * 1.3
                        stb_interval = math.max(1, stb_interval * 0.8)
                     end
                     if score % 10 == 0 then
                        lives = lives + 1
                     end
                  end
                  break
               end
               ::continue2::
            end
         end
      end
      
      ::continue::
   end

   time_since_arm = time_since_arm + delta
   if time_since_arm >= 0.3 then
      maybe_add_stb()
      maybe_arm_z()
      time_since_arm = 0
   end
end

function game_over()
   timer:stop()
   timer = nil
   lives = 0
   local endscreen = gfx.loadpng(dir..'Game_Over.png')
   local scale = screen:get_height() / endscreen:get_height()
   screen:clear()
   screen:copyfrom(endscreen, nil, {x=(screen:get_width() - endscreen:get_width()*scale) / 2,
                                    y=0,
                                    w=endscreen:get_width() * scale,
                                    h=screen:get_height()})
   draw_number(500, 10, score, 5)
   gfx.update()
end

----------------------------------------------------------------------

function random_deviation(value, max_deviation)
   return value * (1 + (math.random() * 2 - 1) * max_deviation)
end

function maybe_add_stb()
   local time_since_last = sys.time() - last_add_time
   if 2*time_since_last > math.random(stb_interval) then
      last_add_time = sys.time()
      local lane = math.random(lanes)
      if devices["stb" .. lane] == nil then
         local speed = random_deviation(stb_speed, 0.15)
         if math.random(2) == 1 then
            device = {surface=all_images['stb'..math.random(4)],
                      x=screen:get_width()-100, y=get_lane_y(lane) + 1,
                      delta_x = -speed, delta_y = 0}
         else
            device = {surface=all_images['fake'..math.random(8)],
                      x=screen:get_width()-100, y=get_lane_y(lane) + 1,
                      delta_x = -speed, delta_y = 0, fake=true}
         end

         devices["stb" .. lane] = device
      end
   end
end

function maybe_arm_z()
   for lane = 1, lanes do
      if devices["z" .. lane] == nil and math.random(10) == 1 then
         devices['z' .. lane] = {surface=all_images.square_logo,
                                 x=65, y=get_lane_y(lane) + 11,
                                 delta_x = 0, delta_y = 0}
      end
   end
end

----------------------------------------------------------------------

function update_cb(timer)
  now = sys.time()
  last_time = last_time or 0
  update_state(now - last_time)
  last_time = now
  if lives > 0 then
    draw_screen()
  else
    game_over()
  end
end

function onKey(key, state)
   if state ~= 'down' then
      return
   end

   if lives == 0 then
      -- local promotion = gfx.loadpng(dir..'promotion.png')
      -- screen:copyfrom(promotion, nil, {x=320,
      --                                 y=screen:get_height() - promotion:get_height()})
      -- gfx.update()
      onStart()
      return
   end

   if key == 'red' then
      lives = lives - 1
   end
   if key == 'green' then
      lives = lives + 1
   end

   local num = tonumber(key)
   if num and num > 0 and num <= lanes then
      if devices['z'..num] and devices['z'..num].delta_x == 0 then
         devices['z'..num].delta_x = z_speed
      end
   end

   print('Key = ' .. key)
end

--start()
