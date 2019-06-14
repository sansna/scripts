# by linxtn
BEGIN{
  FS = ",";
  now = systime();
}
//{
  delete kv;
  for(i=1;i<=NF;i++){
    if(2==split($i, a, ":")){
      kv[a[1]] = a[2];
    }
  }
  pid = kv["pid"];
  mid = kv["mid"];
  ct = int(kv["ct"]);
  stage = int(kv["stage"]);
  fastt = 0
  if("fastt" in kv){
    fastt = int(kv["fastt"])
  }
  liket = 0
  if("liket" in kv){
    liket = int(kv["liket"])
  }
  rept = 0
  if("rept" in kv){
    rept = int(kv["rept"])
  }
  allt = 0
  if("allt" in kv){
    allt = int(kv["allt"])
  }
  disp = 0
  if("v" in kv){
    disp = int(kv["v"]);
  }
  view = 0
  if("detail" in kv){
    view = int(kv["detail"]);
  }
  like = 0
  if("u" in kv){
    like = int(kv["u"]);
  }
  rep1 = 0
  if("r" in kv){
    rep1 = int(kv["r"]);
  }
  rep2 = 0
  if("r2" in kv){
    rep2 = int(kv["r2"]);
  }
  status = 0
  if("status" in kv){
    status = int(kv["status"]);
  }
  forbid = 0
  if("forbid" in kv){
    forbid = int(kv["forbid"]);
  }
  level = -1
  if("level" in kv){
    level = int(kv["level"]);
  }
  age = -1
  if("age" in kv){
    age = int(kv["age"]);
  }
  city = ""
  if("city_code" in kv){
    city = kv["city_code"];
  }
  gender = -1
  if("gender" in kv){
    gender = int(kv["gender"]);
  }
  dura = (now-ct)/(60*30);
  if(dura>1000){
    dura = 1000;
  }
  feed = 0.005*disp+rep1+rep2+like;
  time_rate = 1/(1+exp(-((48-dura)/12)));
  feed_rate = 1/(1+exp(-((20-feed)/6)));
  score = 0.0;
  if(disp>0){
    score = (0.1*view + 1.5*rep1 + 0.8*rep2 + 1.2*like)/disp;
    score = score * time_rate * feed_rate;
    ######
  }
  printf("%s\t%d\t%.8lf\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\n",
         pid, stage, score, strftime("%Y-%m-%d\t%H:%M:%S", ct), disp, view, like, rep1, rep2,
         ct, fastt, liket, rept, allt, mid, status, forbid, level, age, gender, city);
}
