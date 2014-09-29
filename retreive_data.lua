local io = require("io")
local http = require("socket.http")
local ltn12 = require("ltn12")

http.request{ 
    url = "http://www.garshol.priv.no/download/text/http-tut.html", 
    sink = ltn12.sink.file(io.stdout)
}
