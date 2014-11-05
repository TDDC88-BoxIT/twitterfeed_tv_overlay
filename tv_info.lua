
local channel_list = {}
-- Returns a table with available channels. Can be called upon in main.lua like so: 'channel_list = tv_info.get_channel_list()' 
function channel_list.get_channel_list()
	local channel_list = {"SVT1", "SVT2", "TV3", "TV4", "Kanal 5", "TV6"}
	return channel_list;
end
return channel_list
