-- 功能：将hash的field值从一个地方转移到另一个key(int only)
-- hash key
local key = tostring(KEYS[1])
-- hash from
local ffrom = tostring(KEYS[2])
-- hash to
local fto = tostring(KEYS[3])

local val = redis.call('hget', key, ffrom)
if not val then
	return 1
end

val = tonumber(val)
redis.call('hincrby', key, fto, val)
redis.call('hdel', key, ffrom)
return 1
