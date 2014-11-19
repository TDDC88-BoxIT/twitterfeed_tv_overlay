tv_info = require('tv_info')

test_tv_info = {}

function test_tv_info:test_get_channel_list_return_type()

   list = tv_info.get_channel_list()
          
   expected_type = type("string")
   assertEquals(type(list[3]), expected_type)
 end 

function test_tv_info:test_get_channel_is_not_nil()
  
  assertNotNil(tv_info.get_channel_list())
  
end

function test_tv_info:test_get_unixtimestamp_return_type()
  assertEquals(type(os.time()), type(tv_info.get_unixtimestamp()))
end

function test_tv_info:test_get_prog_relinfo_return_equals_same()
  local table_expected = {}
  table_expected.title = {}
  table_expected.title.sv =  "Rönja rövadötter"
  table_expected.start = os.time()
  table_expected.stop = os.time()
  

  table_actual = tv_info.get_prog_relinfo(table_expected)
    
  assertEquals(table_actual["name"], table_expected.title.sv)  
  assertEquals(table_actual["start"], table_expected.start)
   assertEquals(table_actual["stop"], table_expected.stop)
  
end