local s = redis.call('TIME')
--return {table.getn(s), s[1]}
-- s changes from array to int
s=s[1]
return s
