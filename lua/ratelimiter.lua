-- input keys: mid, path
-- args: ts(microsec), mics(microsecs), umics(microsecs), cost, maxburst
-- 本次时间戳（微秒），每令牌释放需要的微秒数(接口/用户)，本次调用消耗次数，最多叠加的爆发次数
-- retval: 1: pass, 0: reject
local ratelimitkey = "sansna_normal_token_rl_key"
local mid = tostring(KEYS[1])
local path = tostring(KEYS[2])
local mp = mid..'_'..path

local mid_ts = mid..'_midts'
local mid_cnt = mid..'_midcnt'
local path_ts = path..'_pathts'
local path_cnt = path..'_pathcnt'
local mp_ts = mp..'_mpts'
local mp_cnt = mp..'_mpcnt'

-- TODO: 对于用户、接口、用户接口的限制和消耗次数应分别设置
-- 当前时间戳（微秒）
local ts = tonumber(ARGV[1])
-- 一个令牌释放需要消耗的微秒数(接口级别/用户级别)
local mics = tonumber(ARGV[2])
local umics = tonumber(ARGV[3])
if not mics then
	-- 默认值
	mics = 1000
end
if not umics then
	-- 默认值
	umics = 20000
end
-- 本次调用消耗的令牌数
local cost = tonumber(ARGV[4])
if not cost then
	-- 默认值
	cost = 1
end
-- 令牌桶容量
local maxburst = tonumber(ARGV[5])
if not maxburst then
	-- 默认值
	maxburst = 80
end

local info = redis.call('hmget', ratelimitkey, mid_ts, mid_cnt, path_ts, path_cnt, mp_ts, mp_cnt)
local result = {}
result.mt = tonumber(info[1])
result.mc = tonumber(info[2])
result.pt = tonumber(info[3])
result.pc = tonumber(info[4])
result.mpt = tonumber(info[5])
result.mpc = tonumber(info[6])

-- 每类型剩余的令牌数
local mid_remains = 0
local path_remains = 0
local mp_remains = 0

if not result.mt then
	-- 用户没访问过,放行
	redis.call('hmset', ratelimitkey, mid_ts, ts, mid_cnt, 0)
else
	-- 尝试用户访问
	local dur = ts - result.mt
	-- lua division 2/1 = 0.5 > 0
	mid_remains = result.mc + (dur / umics)
	if mid_remains > maxburst then
		-- 对于下一波的爆发做限制
		mid_remains = maxburst
	end
	mid_remains = mid_remains - cost
	if mid_remains >= 0 then
		--redis.call('hmset', ratelimitkey, mid_ts, ts, mid_cnt, mid_remains)
	else
		-- 拒绝访问
		return 0
	end
end
if not result.pt then
	-- 接口没访问过,放行
	redis.call('hmset', ratelimitkey, path_ts, ts, path_cnt, 0)
else
	-- 尝试接口访问
	local dur = ts - result.pt
	path_remains = result.pc + (dur / mics)
	if path_remains > maxburst then
		-- 对于下一波的爆发做限制
		path_remains = maxburst
	end
	path_remains = path_remains - cost
	if path_remains >= 0 then
		--redis.call('hmset', ratelimitkey, path_ts, ts, path_cnt, path_remains)
	else
		-- 拒绝访问
		return 0
	end
end
if not result.mpt then
	-- 接口-用户没访问过，放行
	--redis.call('hmset', ratelimitkey, mp_ts, ts, mp_cnt, 0)
else
	-- 尝试接口用户访问
	local dur = ts - result.mpt
	mp_remains = result.mpc + (dur / umics)
	if mp_remains > maxburst then
		-- 对于下一波的爆发做限制
		mp_remains = maxburst
	end
	mp_remains = mp_remains - cost
	if mp_remains >= 0 then
		--redis.call('hmset', ratelimitkey, mp_ts, ts, mp_cnt, mp_remains, mid_ts, ts, mid_cnt, mid_remains, path_ts, ts, path_cnt, path_remains)
	else
		-- 拒绝访问
		return 0
	end
end

redis.call('hmset', ratelimitkey, mp_ts, ts, mp_cnt, mp_remains, mid_ts, ts, mid_cnt, mid_remains, path_ts, ts, path_cnt, path_remains)

return 1
