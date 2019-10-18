from odps.udf import annotate
from datetime import datetime
import time
@annotate("double->bigint")
class age_range(object):
    def evaluate(self, ts):
        try:
            nowdate = datetime.fromtimestamp(int(time.time()))
            ty = nowdate.year
            tm = nowdate.month
            td = nowdate.day
            otherdate = datetime.fromtimestamp(int(ts))
            oy = otherdate.year
            om = otherdate.month
            od = otherdate.day
            ret = 0
            if ty - oy < 0:
                ret = -1
            if ty - oy <= 16:
                ret = 0
            elif ty - oy <= 18:
                ret = 1
            elif ty - oy <= 22:
                ret = 2
            else:
                ret = 3

            if ty - oy in [0, 16, 18, 22]:
                if tm > om:
                    ret += 1
                elif tm == om:
                    if td >= od:
                        ret += 1
            return ret
        except:
            return -2
