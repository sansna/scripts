local s, ms
local now = redis.call('TIME')
s = now[1]
ms=now[2]
return {s,ms}
