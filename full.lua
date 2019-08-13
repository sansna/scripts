-- all keys should contain same {bar} to be hashed to one node.
------dur 1

local dur1 = redis.call('GET', KEYS[1])
if not dur1 then
	dur1 = 0
else
	dur1 = tonumber(dur1)
end
if dur1 >= 7 and dur1 < 15 then
	local v = redis.call('GET', KEYS[4])
	if not v then
		v = 0
	end
	if math.min(v*20+7, 15) <= dur1 then
		return 0
	else
		local w = redis.call('GET', KEYS[7])
		if not w then
			w = 0
		end
		if math.min(w*1+v*20+7, 15) <= dur1 then
			return 0
		end
	end
elseif dur1 >= 15 then
	return 0
end
dur1 = redis.call('INCR', KEYS[1])

if dur1 == 1 then
	redis.call('EXPIRE', KEYS[1], ARGV[1])
end
-----dur 2

local dur2 = redis.call('GET', KEYS[2])
if not dur2 then
	dur2 = 0
else
	dur2 = tonumber(dur2)
end
if dur2 >= 20 and dur2 < 100 then
	local v = redis.call('GET', KEYS[5])
	if not v then
		v = 0
	end
	if math.min(v*20+20, 100) <= dur2 then
		return 0
	else
		local w = redis.call('GET', KEYS[8])
		if not w then
			w = 0
		end
		if math.min(w*1+v*20+7, 15) <= dur1 then
			return 0
		end
	end
elseif dur2 >= 100 then
	return 0
end

local dur2 = redis.call('INCR', KEYS[2])

if dur2 == 1 then
	redis.call('EXPIRE', KEYS[2], ARGV[2])
end
------dur 3

local dur3 = redis.call('GET', KEYS[3])
if not dur3 then
	dur3 = 0
else
	dur3 = tonumber(dur3)
end
if dur3 >= 40 and dur3 < 300 then
	local v = redis.call('GET', KEYS[6])
	if not v then
		v = 0
	end
	if math.min(v*20+40, 300) <= dur3 then
		return 0
	else
		local w = redis.call('GET', KEYS[9])
		if math.min(w*1+v*20+7, 15) <= dur1 then
			return 0
		end
	end
elseif dur3 >= 300 then
	return 0
end

local dur3 = redis.call('INCR', KEYS[3])

if dur3 == 1 then
	redis.call('EXPIRE', KEYS[3], ARGV[3])
end

return 1
