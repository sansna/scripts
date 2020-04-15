--all keys should contain same {bar} to be hashed to one node.
local inc01 = tonumber(ARGV[4])
local inc02 = tonumber(ARGV[5])
local inc03 = tonumber(ARGV[6])
local inc11 = tonumber(ARGV[7])
local inc12 = tonumber(ARGV[8])
local inc13 = tonumber(ARGV[9])

local base1 = tonumber(ARGV[10])
local base2 = tonumber(ARGV[11])
local base3 = tonumber(ARGV[12])
local max1 = tonumber(ARGV[13])
local max2 = tonumber(ARGV[14])
local max3 = tonumber(ARGV[15])

local checkkey = KEYS[10]
local ttl = 0

--check if banned first
local banned = redis.call('GET', checkkey)
if not banned then
	banned = 0
else
	return tonumber(banned)
end
--checkkey not set

------dur 1

local dur1 = redis.call('GET', KEYS[1])
if not dur1 then
	dur1 = 0
else
	dur1 = tonumber(dur1)
end
if dur1 >= base1 and dur1 < max1 then
	local v = redis.call('GET', KEYS[4])
	if not v then
		v = 0
	end
	local w = redis.call('GET', KEYS[7])
	if not w then
		w = 0
	end
	if math.min(w*inc11+v*inc01+base1, max1) <= dur1 then
		ttl = redis.call('TTL', KEYS[1])
		if ttl == -2 then
			ttl = ARGV[16]
		end
		redis.call('SETEX', checkkey, ttl, 1)
		return 1
	end
elseif dur1 >= max1 then
	ttl = redis.call('TTL', KEYS[1])
	if ttl == -2 then
		ttl = ARGV[16]
	end
	redis.call('SETEX', checkkey, ttl, 1)
	return 1
end

-----dur 2

local dur2 = redis.call('GET', KEYS[2])
if not dur2 then
	dur2 = 0
else
	dur2 = tonumber(dur2)
end
if dur2 >= base2 and dur2 < max2 then
	local v = redis.call('GET', KEYS[5])
	if not v then
		v = 0
	end
	local w = redis.call('GET', KEYS[8])
	if not w then
		w = 0
	end
	if math.min(w*inc12+v*inc02+base2, max2) <= dur2 then
		ttl = redis.call('TTL', KEYS[2])
		if ttl == -2 then
			ttl = ARGV[17]
		end
		redis.call('SETEX', checkkey, ttl, 2)
		return 2
	end
elseif dur2 >= max2 then
	ttl = redis.call('TTL', KEYS[2])
	if ttl == -2 then
		ttl = ARGV[17]
	end
	redis.call('SETEX', checkkey, ttl, 2)
	return 2
end

------dur 3

local dur3 = redis.call('GET', KEYS[3])
if not dur3 then
	dur3 = 0
else
	dur3 = tonumber(dur3)
end
if dur3 >= base3 and dur3 < max3 then
	local v = redis.call('GET', KEYS[6])
	if not v then
		v = 0
	end
	local w = redis.call('GET', KEYS[9])
	if not w then
		w = 0
	end
	if math.min(w*inc13+v*inc03+base3, max3) <= dur3 then
		ttl = redis.call('TTL', KEYS[3])
		if ttl == -2 then
			ttl = ARGV[18]
		end
		redis.call('SETEX', checkkey, ttl, 3)
		return 3
	end
elseif dur3 >= max3 then
	ttl = redis.call('TTL', KEYS[3])
	if ttl == -2 then
		ttl = ARGV[18]
	end
	redis.call('SETEX', checkkey, ttl, 3)
	return 3
end

return 0
