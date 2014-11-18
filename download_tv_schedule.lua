local http=require ("socket.http")

-- downloads todays tv_schedules for channels svt1-tv6 to six different json files in json folder
function download_webpage()
  current_date = os.date("%Y-%m-%d")
  res, code, headers, status = http.request([[http://json.xmltv.se/svt1.svt.se_2014-11-27.js.gz]])
  print(headers)
end

download_webpage()
-- adresses:
-- svt1: http://json.xmltv.se/svt1.svt.se_2014-11-27.js.gz
-- svt2: http://json.xmltv.se/svt2.svt.se_2014-11-27.js.gz
-- tv3: http://json.xmltv.se/tv3.se_2014-11-27.js.gz
-- tv4 : http://json.xmltv.se/tv4.se_2014-11-25.js.gz
-- kanal 5: http://json.xmltv.se/kanal5.se_2014-11-27.js.gz
-- tv6 : http://json.xmltv.se/tv6.se_2014-11-27.js.gz

