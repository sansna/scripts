--odps sql 
--********************************************************************--
--author:wangwentao
--create time:2019-09-15 23:17:10
--********************************************************************--

--#########################有效会话############################
-- effective chat
-- total
INSERT INTO TABLE dnu_core_effect_chat PARTITION (p_date) 
SELECT  ROUND(COUNT(c.mid)/COUNT(a.mid),3) AS effective_percent -- 有效会话总用户占比
        ,ROUND(SUM(c.uv)/COUNT(a.mid),3) AS avg_effect -- 人均有效会话
        , 'total' as type
        , a.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE p_date=TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) a LEFT
JOIN    (
            SELECT  b.mid AS mid
                    ,COUNT(b.uid) AS uv
            FROM    (
                        SELECT  a.mid AS mid
                                ,a.uid AS uid
                                ,COUNT(*) AS cnt
                        FROM    (
                                    SELECT  mid
                                            ,GET_JSON_OBJECT(data, '$.touser') AS uid
                                    FROM    im_chat
                                    WHERE   ymd = '${day}'
                                    AND     type = 'chat_create'
                                    AND     stype = 'chat'
                                    AND     GET_JSON_OBJECT(data, '$.app_name') = 'hanabi'
                                    AND     GET_JSON_OBJECT(data, '$.mtype') <> 200
                                    UNION ALL
                                    SELECT  GET_JSON_OBJECT(data, '$.touser') AS mid
                                            ,mid AS uid
                                    FROM    im_chat
                                    WHERE   ymd = '${day}'
                                    AND     type = 'chat_create'
                                    AND     stype = 'chat'
                                    AND     GET_JSON_OBJECT(data, '$.app_name') = 'hanabi'
                                    AND     GET_JSON_OBJECT(data, '$.mtype') <> 200
                                ) AS a
                        GROUP BY a.mid
                                 ,a.uid
                    ) AS b
            WHERE   b.cnt >= 30
            GROUP BY b.mid
        ) c
ON      a.mid = c.mid
GROUP BY a.p_date; 

-- gender
INSERT INTO TABLE dnu_core_effect_chat PARTITION (p_date) 
SELECT  ROUND(COUNT(c.mid)/COUNT(a.mid),3) AS effective_percent -- 有效会话总用户占比
        ,ROUND(SUM(c.uv)/COUNT(a.mid),3) AS avg_effect -- 人均有效会话
        , a.gender as type
        , a.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE p_date=TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) a LEFT
JOIN    (
            SELECT  b.mid AS mid
                    ,COUNT(b.uid) AS uv
            FROM    (
                        SELECT  a.mid AS mid
                                ,a.uid AS uid
                                ,COUNT(*) AS cnt
                        FROM    (
                                    SELECT  mid
                                            ,GET_JSON_OBJECT(data, '$.touser') AS uid
                                    FROM    im_chat
                                    WHERE   ymd = '${day}'
                                    AND     type = 'chat_create'
                                    AND     stype = 'chat'
                                    AND     GET_JSON_OBJECT(data, '$.app_name') = 'hanabi'
                                    AND     GET_JSON_OBJECT(data, '$.mtype') <> 200
                                    UNION ALL
                                    SELECT  GET_JSON_OBJECT(data, '$.touser') AS mid
                                            ,mid AS uid
                                    FROM    im_chat
                                    WHERE   ymd = '${day}'
                                    AND     type = 'chat_create'
                                    AND     stype = 'chat'
                                    AND     GET_JSON_OBJECT(data, '$.app_name') = 'hanabi'
                                    AND     GET_JSON_OBJECT(data, '$.mtype') <> 200
                                ) AS a
                        GROUP BY a.mid
                                 ,a.uid
                    ) AS b
            WHERE   b.cnt >= 30
            GROUP BY b.mid
        ) c
ON      a.mid = c.mid
GROUP BY a.p_date, a.gender; 

-- dt
INSERT INTO TABLE dnu_core_effect_chat PARTITION (p_date) 
SELECT  ROUND(COUNT(c.mid)/COUNT(a.mid),3) AS effective_percent -- 有效会话总用户占比
        ,ROUND(SUM(c.uv)/COUNT(a.mid),3) AS avg_effect -- 人均有效会话
        , a.dt as type
        , a.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE p_date=TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) a LEFT
JOIN    (
            SELECT  b.mid AS mid
                    ,COUNT(b.uid) AS uv
            FROM    (
                        SELECT  a.mid AS mid
                                ,a.uid AS uid
                                ,COUNT(*) AS cnt
                        FROM    (
                                    SELECT  mid
                                            ,GET_JSON_OBJECT(data, '$.touser') AS uid
                                    FROM    im_chat
                                    WHERE   ymd = '${day}'
                                    AND     type = 'chat_create'
                                    AND     stype = 'chat'
                                    AND     GET_JSON_OBJECT(data, '$.app_name') = 'hanabi'
                                    AND     GET_JSON_OBJECT(data, '$.mtype') <> 200
                                    UNION ALL
                                    SELECT  GET_JSON_OBJECT(data, '$.touser') AS mid
                                            ,mid AS uid
                                    FROM    im_chat
                                    WHERE   ymd = '${day}'
                                    AND     type = 'chat_create'
                                    AND     stype = 'chat'
                                    AND     GET_JSON_OBJECT(data, '$.app_name') = 'hanabi'
                                    AND     GET_JSON_OBJECT(data, '$.mtype') <> 200
                                ) AS a
                        GROUP BY a.mid
                                 ,a.uid
                    ) AS b
            WHERE   b.cnt >= 30
            GROUP BY b.mid
        ) c
ON      a.mid = c.mid
GROUP BY a.p_date, a.dt; 

-- agerange
INSERT INTO TABLE dnu_core_effect_chat PARTITION (p_date) 
SELECT  ROUND(COUNT(c.mid)/COUNT(a.mid),3) AS effective_percent -- 有效会话总用户占比
        ,ROUND(SUM(c.uv)/COUNT(a.mid),3) AS avg_effect -- 人均有效会话
        , CAST(a.age_range as STRING) as type
        , a.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE p_date=TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) a LEFT
JOIN    (
            SELECT  b.mid AS mid
                    ,COUNT(b.uid) AS uv
            FROM    (
                        SELECT  a.mid AS mid
                                ,a.uid AS uid
                                ,COUNT(*) AS cnt
                        FROM    (
                                    SELECT  mid
                                            ,GET_JSON_OBJECT(data, '$.touser') AS uid
                                    FROM    im_chat
                                    WHERE   ymd = '${day}'
                                    AND     type = 'chat_create'
                                    AND     stype = 'chat'
                                    AND     GET_JSON_OBJECT(data, '$.app_name') = 'hanabi'
                                    AND     GET_JSON_OBJECT(data, '$.mtype') <> 200
                                    UNION ALL
                                    SELECT  GET_JSON_OBJECT(data, '$.touser') AS mid
                                            ,mid AS uid
                                    FROM    im_chat
                                    WHERE   ymd = '${day}'
                                    AND     type = 'chat_create'
                                    AND     stype = 'chat'
                                    AND     GET_JSON_OBJECT(data, '$.app_name') = 'hanabi'
                                    AND     GET_JSON_OBJECT(data, '$.mtype') <> 200
                                ) AS a
                        GROUP BY a.mid
                                 ,a.uid
                    ) AS b
            WHERE   b.cnt >= 30
            GROUP BY b.mid
        ) c
ON      a.mid = c.mid
GROUP BY a.p_date, a.age_range; 

----#########################新建会话############################
------ session_create
-- total
INSERT INTO TABLE dnu_core_session_create PARTITION (p_date) 
SELECT  COUNT(*) AS sum_dnu    -- 总新增人数
        ,ROUND(AVG(g.cnt),3) AS avg_sess_create    -- 总体平均新建会话数
        , 'total' as type
        , d.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE   p_date = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) d LEFT
JOIN    (
            SELECT  mid
                    ,SUM(cnt) AS cnt
            FROM    (
                        SELECT  mid
                                ,COUNT(*) AS cnt
                        FROM    im_chat
                        WHERE   ymd = '${day}'
                        AND     GET_JSON_OBJECT(data,'$.app_name') = 'hanabi'
                        AND     type = 'session_create'
                        AND     stype = 'chat'
                        GROUP BY mid
                                 ,GET_JSON_OBJECT(data,'$.touser')
                        UNION ALL
                        SELECT  GET_JSON_OBJECT(data, '$.touser') AS mid
                                ,COUNT(*) AS cnt
                        FROM    im_chat
                        WHERE   ymd = '${day}'
                        AND     GET_JSON_OBJECT(data,'$.app_name') = 'hanabi'
                        AND     type = 'session_create'
                        AND     stype = 'chat'
                        GROUP BY mid
                                 ,GET_JSON_OBJECT(data,'$.touser')
                    ) f
            GROUP BY f.mid
        ) AS g
ON      d.mid = g.mid
GROUP BY d.p_date;

-- gender
INSERT INTO TABLE dnu_core_session_create PARTITION (p_date) 
SELECT  COUNT(*) AS sum_dnu    -- 总新增人数
        ,ROUND(AVG(g.cnt),3) AS avg_sess_create    -- 总体平均新建会话数
        , d.gender as type
        , d.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE   p_date = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) d LEFT
JOIN    (
            SELECT  mid
                    ,SUM(cnt) AS cnt
            FROM    (
                        SELECT  mid
                                ,COUNT(*) AS cnt
                        FROM    im_chat
                        WHERE   ymd = '${day}'
                        AND     GET_JSON_OBJECT(data,'$.app_name') = 'hanabi'
                        AND     type = 'session_create'
                        AND     stype = 'chat'
                        GROUP BY mid
                                 ,GET_JSON_OBJECT(data,'$.touser')
                        UNION ALL
                        SELECT  GET_JSON_OBJECT(data, '$.touser') AS mid
                                ,COUNT(*) AS cnt
                        FROM    im_chat
                        WHERE   ymd = '${day}'
                        AND     GET_JSON_OBJECT(data,'$.app_name') = 'hanabi'
                        AND     type = 'session_create'
                        AND     stype = 'chat'
                        GROUP BY mid
                                 ,GET_JSON_OBJECT(data,'$.touser')
                    ) f
            GROUP BY f.mid
        ) AS g
ON      d.mid = g.mid
GROUP BY d.p_date, d.gender;

-- dt
INSERT INTO TABLE dnu_core_session_create PARTITION (p_date) 
SELECT  COUNT(*) AS sum_dnu    -- 总新增人数
        ,ROUND(AVG(g.cnt),3) AS avg_sess_create    -- 总体平均新建会话数
        , d.dt as type
        , d.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE   p_date = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) d LEFT
JOIN    (
            SELECT  mid
                    ,SUM(cnt) AS cnt
            FROM    (
                        SELECT  mid
                                ,COUNT(*) AS cnt
                        FROM    im_chat
                        WHERE   ymd = '${day}'
                        AND     GET_JSON_OBJECT(data,'$.app_name') = 'hanabi'
                        AND     type = 'session_create'
                        AND     stype = 'chat'
                        GROUP BY mid
                                 ,GET_JSON_OBJECT(data,'$.touser')
                        UNION ALL
                        SELECT  GET_JSON_OBJECT(data, '$.touser') AS mid
                                ,COUNT(*) AS cnt
                        FROM    im_chat
                        WHERE   ymd = '${day}'
                        AND     GET_JSON_OBJECT(data,'$.app_name') = 'hanabi'
                        AND     type = 'session_create'
                        AND     stype = 'chat'
                        GROUP BY mid
                                 ,GET_JSON_OBJECT(data,'$.touser')
                    ) f
            GROUP BY f.mid
        ) AS g
ON      d.mid = g.mid
GROUP BY d.p_date, d.dt;

-- age_range
INSERT INTO TABLE dnu_core_session_create PARTITION (p_date) 
SELECT  COUNT(*) AS sum_dnu    -- 总新增人数
        ,ROUND(AVG(g.cnt),3) AS avg_sess_create    -- 总体平均新建会话数
        , CAST(d.age_range as STRING) as type
        , d.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE   p_date = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) d LEFT
JOIN    (
            SELECT  mid
                    ,SUM(cnt) AS cnt
            FROM    (
                        SELECT  mid
                                ,COUNT(*) AS cnt
                        FROM    im_chat
                        WHERE   ymd = '${day}'
                        AND     GET_JSON_OBJECT(data,'$.app_name') = 'hanabi'
                        AND     type = 'session_create'
                        AND     stype = 'chat'
                        GROUP BY mid
                                 ,GET_JSON_OBJECT(data,'$.touser')
                        UNION ALL
                        SELECT  GET_JSON_OBJECT(data, '$.touser') AS mid
                                ,COUNT(*) AS cnt
                        FROM    im_chat
                        WHERE   ymd = '${day}'
                        AND     GET_JSON_OBJECT(data,'$.app_name') = 'hanabi'
                        AND     type = 'session_create'
                        AND     stype = 'chat'
                        GROUP BY mid
                                 ,GET_JSON_OBJECT(data,'$.touser')
                    ) f
            GROUP BY f.mid
        ) AS g
ON      d.mid = g.mid
GROUP BY d.p_date, d.age_range;

----#########################遇见数据############################
---- meet_usage
-- total
INSERT INTO TABLE dnu_core_meet_usage PARTITION (p_date) 
SELECT  ROUND(COUNT(t2.mid)/COUNT(t1.mid),3) AS use_rate
        ,ROUND(AVG(t2.cnt),3) AS avg_meet_cnt
        , 'total' as type
        , t1.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE   p_date = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) t1 LEFT
JOIN    (
            SELECT  mid
                    ,COUNT(*) AS cnt
            FROM    hanabi_actionlog
            WHERE   atype = 'other-other'
            AND     ym = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymm')
            AND     DAY = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'dd')
            AND     type = 'start'
            AND     stype = 'meet'
            GROUP BY mid
        ) t2
ON      t1.mid = t2.mid
GROUP BY t1.p_date;

-- gender
INSERT INTO TABLE dnu_core_meet_usage PARTITION (p_date) 
SELECT  ROUND(COUNT(t2.mid)/COUNT(t1.mid),3) AS use_rate
        ,ROUND(AVG(t2.cnt),3) AS avg_meet_cnt
        , t1.gender as type
        , t1.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE   p_date = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) t1 LEFT
JOIN    (
            SELECT  mid
                    ,COUNT(*) AS cnt
            FROM    hanabi_actionlog
            WHERE   atype = 'other-other'
            AND     ym = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymm')
            AND     DAY = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'dd')
            AND     type = 'start'
            AND     stype = 'meet'
            GROUP BY mid
        ) t2
ON      t1.mid = t2.mid
GROUP BY t1.p_date, t1.gender;

-- dt
INSERT INTO TABLE dnu_core_meet_usage PARTITION (p_date) 
SELECT  ROUND(COUNT(t2.mid)/COUNT(t1.mid),3) AS use_rate
        ,ROUND(AVG(t2.cnt),3) AS avg_meet_cnt
        , t1.dt as type
        , t1.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE   p_date = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) t1 LEFT
JOIN    (
            SELECT  mid
                    ,COUNT(*) AS cnt
            FROM    hanabi_actionlog
            WHERE   atype = 'other-other'
            AND     ym = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymm')
            AND     DAY = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'dd')
            AND     type = 'start'
            AND     stype = 'meet'
            GROUP BY mid
        ) t2
ON      t1.mid = t2.mid
GROUP BY t1.p_date, t1.dt;

-- age_range
INSERT INTO TABLE dnu_core_meet_usage PARTITION (p_date) 
SELECT  ROUND(COUNT(t2.mid)/COUNT(t1.mid),3) AS use_rate
        ,ROUND(AVG(t2.cnt),3) AS avg_meet_cnt
        , CAST(t1.age_range as STRING) as type
        , t1.p_date as p_date
FROM    (
            SELECT  *
            FROM    dnu_core_with_agerange
            WHERE   p_date = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymmdd')
        ) t1 LEFT
JOIN    (
            SELECT  mid
                    ,COUNT(*) AS cnt
            FROM    hanabi_actionlog
            WHERE   atype = 'other-other'
            AND     ym = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'yyyymm')
            AND     DAY = TO_CHAR(TO_DATE('${day}','yyyy-mm-dd') ,'dd')
            AND     type = 'start'
            AND     stype = 'meet'
            GROUP BY mid
        ) t2
ON      t1.mid = t2.mid
GROUP BY t1.p_date, t1.age_range;
