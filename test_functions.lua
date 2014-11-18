--test functions, run this file from terminal
tv_info = scrum1.require('tv_info')

--test of the get_date_unixtimestamp()
print("test the unixtimestamp function")
--here is a list with possible timestamps that match programs for monday 141110
--1415577600
--1415577900
--1415579400
--1415579700
--1415581200
--1415581500
--1415583000
--1415583300
--1415584800
--1415585100
--1415586600
--1415586900
--1415588400
--1415588700
--1415590200
--1415590500
--1415592000
--1415592300
--1415593800
--1415604300
--1415606100
--1415606400
--1415631600
--1415631900
--1415632800
--1415635500
--1415636100
--1415636400
--1415637000
--1415637900
--1415638800
--1415641500
--1415641800
--1415642400
--1415644200
--1415646000
--1415649600
--1415652000
--1415652300
--1415652900
--1415653200
--1415654100
--1415655900
--1415659200
--1415661900
--1415663700
curtime = tv_info.get_unixtimestamp()
print(curtime)
print("")
print("test the get_prog_allinfo()")
print(type(tv_info.get_prog_allinfo(curtime)))
print("")
print("test the get_prgram_relinfo()")
relevant_tv_info = {}
relevant_tv_info = tv_info.get_prog_relinfo(tv_info.get_prog_allinfo(curtime))
print(relevant_tv_info["name"])
