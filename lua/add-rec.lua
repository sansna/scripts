-- input 7: pid, start, stop, npage, pos, prefix, upsert
-- output: 0,1

local pid=tostring(KEYS[1])
local start=tonumber(KEYS[2])
local stop=tonumber(KEYS[3])
local npage=tonumber(KEYS[4])
local pos=tonumber(KEYS[5])
local prefix=tostring(KEYS[6])
local upsert=tonumber(KEYS[7])
-- timestamp
local now = redis.call('TIME')
now = tonumber(now[1])

if upsert == 0 then
	upsert = false
else
	upsert = true
end

-- detect existence
local key_allpagepos = prefix.."_all_page_pos"
local field_pagepos = tostring(npage)..tostring(pos)
local key_allpids = prefix..'_edit_rect_pids'
local key_hashpid = prefix..'_pid_'
local key = key_hashpid..pid
if redis.call('HEXISTS', key_allpagepos, field_pagepos) == 1 then
	if not upsert then
		return 0
	end
	-- remove the pid 
	redis.call('DEL', key_hashpid..tostring(redis.call('HGET', key_allpagepos, field_pagepos)))
else
	redis.call('HSET', key_allpagepos, field_pagepos, tonumber(pid))
end

-- set
redis.call('SADD', key_allpids, pid)
redis.call('HMSET', key, 'start', start, 'pos', pos, 'npage', npage)
if stop ~= 0 and stop > now then
	redis.call('EXPIRE', key, stop-now)
end

return 1
