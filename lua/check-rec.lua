-- input 2: prefix, mid
-- output: [{pid,pos},..]

local prefix=KEYS[1]
local mid=tostring(KEYS[2])
local key_allpids = prefix..'_edit_rect_pids'
local key_hashpid = prefix..'_pid_'
-- timestamp
local now = redis.call('TIME')
now = tonumber(now[1])

local hgetall = function (key)
	local bulk = redis.call('HGETALL', key)
	local result = {}
	local nextkey
	for i, v in ipairs(bulk) do
		if i % 2 == 1 then
			nextkey = v
		else
			result[nextkey] = v
		end
	end
	return result
end

local hmget = function (key, ...)
	if next(arg) == nil then return {} end
	local bulk = redis.call('HMGET', key, unpack(arg))
	local result = {}
	for i, v in ipairs(bulk) do result[ arg[i] ] = v end
	return result
end

local process_one = function (pid)
	local result = {}
	local key = key_hashpid..tostring(pid)
	local ret = hmget(key,'start','pos','npage')
	local start = tonumber(ret['start'])
	if start > now then
		return false
	end
	local pos = tonumber(ret['pos'])
	local npage = tonumber(ret['npage'])
	if redis.call('HINCRBY', key, mid, 1) == npage then
		result.pos = pos
		result.pid = pid
		return result
	end
end

local smems = redis.call('SMEMBERS', key_allpids)
local result = {}
for i, v in ipairs(smems) do
	repeat
		-- fetch pid related info
		local ttl = redis.call('TTL', key_hashpid..tostring(v))
		if ttl == -2 then
			redis.call('SREM', key_allpids, v)
			break
		end
		local ret = process_one(v)
		if ret and ret['pid'] ~= 0 then
			table.insert(result, ret)
		end
	until true
end
return cjson.encode(result)
