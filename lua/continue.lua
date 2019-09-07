-- lua gte 5.2
local ret = redis.call('TIME')
local s
for i,v in ipairs(ret) do 
	goto cont
	s = v
	::cont::
end
return s

-- lua lt 5.2
--for i, v in ipairs(ret) do
--	repeat
--		s = v
--		break
--	until true
--end
