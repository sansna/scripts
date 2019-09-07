-- this works
local a = 123
local sss = function ()
	-- returns outer a's value
	return a
end

return sss()
