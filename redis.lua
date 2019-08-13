local dur1 = redis.call('INCR', KEYS[1])

if dur1 == 1 then
	redis.call('EXPIRE', KEYS[1], ARGV[1])
end

local dur2 = redis.call('INCR', KEYS[2])

if dur2 == 1 then
	redis.call('EXPIRE', KEYS[2], ARGV[2])
end

local dur3 = redis.call('INCR', KEYS[3])

if dur3 == 1 then
	redis.call('EXPIRE', KEYS[3], ARGV[3])
end

return {dur1, dur2, dur3}
