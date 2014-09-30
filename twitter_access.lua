local consumer_key = "KJg7JySTCc04NWAsdLSLh3zCF"
local consumer_secret = "5MNunCOwnlf3RqC2qRsCrtAQlJ8aPXT9TgeUGlHzFb4DU3uNrj"

local OAuth = require("lib/OAuth")
local json = require("json")

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
  local tokens = json.decode(lines)
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
  for k, v in pairs(values) do
      print(k,v)
  end
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
  
  
  print(json.encode(token_table))
  local f = io.open("tokens.json","wb")
  io.output(f)
  io.write(json.encode(token_table))
  io.close(f)
end



local response_code, response_headers, response_status_line, response_body = 
    client:PerformRequest("GET", "https://api.twitter.com/1.1/search/tweets.json", {q = "Paradise hotel"})
print("response_code", response_code)
print("response_status_line", response_status_line)
for k,v in pairs(response_headers) do print(k,v) end
print("response_body", response_body)


