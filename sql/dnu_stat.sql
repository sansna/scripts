--odps sql 
--********************************************************************--
--author:wangwentao
--create time:2019-09-15 19:19:18
--********************************************************************--
set odps.sql.type.system.odps2=true;

INSERT INTO TABLE dnu_core_with_agerange PARTITION(p_date)
SELECT  mid AS mids
        ,CASE    WHEN GET_JSON_OBJECT(data, '$.gender') == 1 THEN 'Male'
                 WHEN GET_JSON_OBJECT(data,'$.gender') == 2 THEN 'Female' 
                 ELSE 'Unknown' 
         END AS gender
        ,CASE    WHEN GET_JSON_OBJECT(data, '$.dt') == 0 THEN 'android'
                 WHEN GET_JSON_OBJECT(data, '$.dt') == 1 THEN 'apple' 
                 ELSE 'Unknown' 
         END AS dt
        ,CAST(GET_JSON_OBJECT(data, '$.birth')/1000 AS BIGINT) AS birth
        ,age_range(CAST(GET_JSON_OBJECT(data, '$.birth') AS BIGINT)/1000) AS age_range
        ,CAST(ct as BIGINT) as ct
        ,'${day}' as p_date
FROM    hanabi_actionlog
WHERE   atype = 'other-other'
AND     ym = SUBSTR('${day}',1,6)
AND     day = SUBSTR('${day}',7)  
AND     type = 'user'
AND     stype = 'register'
AND     mid <> 0
