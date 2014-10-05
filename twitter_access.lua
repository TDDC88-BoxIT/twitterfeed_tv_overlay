local consumer_key = "KJg7JySTCc04NWAsdLSLh3zCF"
local consumer_secret = "5MNunCOwnlf3RqC2qRsCrtAQlJ8aPXT9TgeUGlHzFb4DU3uNrj"

local function matrix_to_string( tab, padding,padding_char,white_pixel,black_pixel )
    local padding_string
    local str_tab = {} -- hold each row of the qr code in a cell

    -- Add (padding) blank columns at the left of the matrix
    -- (left of each row string), inserting an extra (padding)
    -- rows at the top and bottom
    padding_string = string.rep(padding_char,padding)
    for i=1,#tab + 2*padding do
        str_tab[i] = padding_string
    end

    for x=1,#tab do
        for y=1,#tab do
            if tab[x][y] > 0 then
                -- using y + padding because we added (padding) blank columns at the left for each string in str_tab array
                str_tab[y + padding] = str_tab[y + padding] .. black_pixel
            elseif tab[x][y] < 0 then
                str_tab[y + padding] = str_tab[y + padding] .. white_pixel
            else
                str_tab[y + padding] = str_tab[y + padding] .. " X"
            end
        end
    end

    padding_string = string.rep(padding_char,#tab)
    for i=1,padding do
        -- fills in padding rows at top of matrix
        str_tab[i] =  str_tab[i] .. padding_string
        -- fills in padding rows at bottom of matrix
        str_tab[#tab + padding + i] =  str_tab[#tab + padding + i] .. padding_string
    end

  -- Add (padding) blank columns to right of matrix (to the end of each row string)
    padding_string = string.rep(padding_char,padding)
    for i=1,#tab + 2*padding do
        str_tab[i] = str_tab[i] .. padding_string
    end

    return str_tab
end

local OAuth = require("lib/OAuth")
local json = require("JSON")
local qr = require("qrencode")

local f = io.open("tokens.json","rb")
if f then 
  f:close() 
end

if f ~= nil then
  -- File exists
  --file = io.open("tokens.json","rb")
  local lines = ""
  for line in io.lines("tokens.json") do 
    lines = lines .. line
  end
  --io.close(f)
  local tokens = json:decode(lines)
  client = OAuth.new(consumer_key, consumer_secret, {
      RequestToken = "https://api.twitter.com/oauth/request_token", 
      AuthorizeUser = {"https://api.twitter.com/oauth/authorize", method = "GET"},
      AccessToken = "https://api.twitter.com/oauth/access_token"
  }, {
      OAuthToken = tokens.oauth_token,
      OAuthTokenSecret = tokens.oauth_token_secret
  })
else
  local client = OAuth.new(consumer_key, consumer_secret, {
      RequestToken = "https://api.twitter.com/oauth/request_token", 
      AuthorizeUser = {"https://api.twitter.com/oauth/authorize", method = "GET"},
      AccessToken = "https://api.twitter.com/oauth/access_token"
  }) 
  local callback_url = "oob"
  local values = client:RequestToken({ oauth_callback = callback_url })
  local oauth_token = values.oauth_token  -- we'll need both later
  local oauth_token_secret = values.oauth_token_secret

  local tracking_code = "58435"   -- this is some random value
  local new_url = client:BuildAuthorizationUrl({ oauth_callback = callback_url, state = tracking_code })

  print("Navigate to this url with your browser, please...")
  print(new_url)
  local ok, tab_or_message = qr.qrcode(new_url)
  local rows
  rows = matrix_to_string(tab_or_message,1,0,' ','█')
  for i=1,#rows do  -- prints each "row" of the QR code on a line, one at a time
      print(rows[i])
  end
  print("\r\nOnce you have logged in and authorized the application, enter the PIN")

  local oauth_verifier = assert(io.read("*n"))    -- read the PIN from stdin
  oauth_verifier = tostring(oauth_verifier)       -- must be a string

  ---- now we'll use the tokens we got in the RequestToken call, plus our PIN
  local client = OAuth.new(consumer_key, consumer_secret, {
      RequestToken = "https://api.twitter.com/oauth/request_token", 
      AuthorizeUser = {"https://api.twitter.com/oauth/authorize", method = "GET"},
      AccessToken = "https://api.twitter.com/oauth/access_token"
  }, {
      OAuthToken = oauth_token,
      OAuthVerifier = oauth_verifier
  })
  client:SetTokenSecret(oauth_token_secret)

  local values, err, headers, status, body = client:GetAccessToken()
  --for k, v in pairs(values) do
  --    print(k,v)
  --end
  local oauth_token = values.oauth_token  -- we'll need both later
  local oauth_token_secret = values.oauth_token_secret

  client = OAuth.new(consumer_key, consumer_secret, {
      RequestToken = "https://api.twitter.com/oauth/request_token", 
      AuthorizeUser = {"https://api.twitter.com/oauth/authorize", method = "GET"},
      AccessToken = "https://api.twitter.com/oauth/access_token"
  }, {
      OAuthToken = oauth_token,
      OAuthTokenSecret = oauth_token_secret
  })
  
  local token_table = {}
  token_table['oauth_token'] = oauth_token
  token_table['oauth_token_secret'] = oauth_token_secret
  
  
  --print(json:encode(token_table))
  local f = io.open("tokens.json","wb")
  io.output(f)
  io.write(json:encode(token_table))
  io.close(f)
end


while true do
  io.write("Enter search string (or q to quit): ")
  local query = tostring(io.read())
  if query == 'q' then
    break
  end
  
  local response_code, response_headers, response_status_line, response_body = 
      client:PerformRequest("GET", "https://api.twitter.com/1.1/search/tweets.json", {q = query, count = 5})
  --print("response_code", response_code)
  --print("response_status_line", response_status_line)
  --for k,v in pairs(response_headers) do print(k,v) end
  --print("response_body", response_body)

  local data = json:decode(response_body)
  for k,v in pairs(data.statuses) do
    print('@' .. v.user.screen_name .. ': ' .. v.text)
  end

end 
