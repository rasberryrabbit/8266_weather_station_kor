_G.ContLen=-1
_G.last_remain=""
_G.timeoffset=9*3600
_G.to_send=""
_G.imgoffset=0
_G.weinfo={}
_G.rtm=rtctime.get()

local WeTable={['Clear']='01',['Partly Cloudy']='02',['Mostly Cloudy']='04',['Cloudy']='03',['Rain']='09',['Rain/Snow']='10',['Snow']='13'}

sk=net.createConnection(net.TCP, 0)
sk:on("receive", function(sck, c)
    if _G.ContLen==-1 then
      i=nil
      jh=0
      repeat
        iposh=jh+1
        ih,jh = string.find(c,"\n",iposh)
        if ih==nil or iposh==jh then
          i=iposh
          break
        end
      until ih==nil

      if i~=nil then
        _G.ContLen=tonumber(string.match(c,"Content%-Length:%s+(%d+)"))
        if _G.ContLen==nil then
          _G.ContLen=8192
        end
        c=string.sub(c,i,-1)
      end
    end
    ilen=string.len(c)
    _G.ContLen=_G.ContLen-ilen
    if _G.ContLen<=0 then
      _G.weinfo["h3"]=1
    end
    if _G.weinfo["h2"]~=nil then
      c=nil
      return
    end
    c=_G.last_remain..c
    _G.last_remain=""
    if _G.imgoffset>2 then
      c=nil
      return
    end
    cpos=1
    spos=1
    epos=nil
    slen=string.len(c)
    local i,j
    while cpos<=slen do
      i, j = string.find(c,"<data ",cpos)
      if i==nil then
        i, j = string.find(c,"</data>",cpos)
      end
      if i==nil then           
        if epos==nil then
          epos=1
        end
        _G.last_remain=string.sub(c,epos)
        break
      else
        spos=epos
        epos=i
        if spos~=nil then
          stime=string.match(c,'<hour>(%d+)',spos)
          stemp=string.match(c,'<temp>([0-9%.]+)',spos)
          shum=string.match(c,'<reh>(%d+)',spos)
          swind=string.match(c,'<ws>([0-9%.]+)',spos)
          scond=string.match(c,'<wfEn>([^<]+)',spos)
          spop=string.match(c,'<pop>(%d+)',spos)
          if _G.imgoffset<3 then
            dayw=tonumber(stime)
            ctemp=tonumber(stemp)
            windspd=tonumber(swind)
            hum=tonumber(shum)
            wpop=tonumber(spop)
            weicon=WeTable[scond]
            if weicon~=nil then
                if dayw>18 or dayw<6 then
                  weicon="we_"..weicon.."n.bin"
                else
                  weicon="we_"..weicon.."d.bin"
                end
            else
              weicon=scond
            end
            _G.weinfo["h".._G.imgoffset]={temp=ctemp, humi=hum, icon=weicon, wtime=dayw, wind=windspd, pop=wpop}
            _G.imgoffset=_G.imgoffset+1
            --print("Forecast")
          end
        end
        cpos=i+1
      end
    end
    c=nil
end)
sk:on("connection", function(sck, c)
  _G.weinfo["h0"]=nil
  _G.weinfo["h3"]=nil
  _G.last_remain=""
  _G.ContLen=-1
  _G.imgoffset=0
  sck:send(_G.to_send)
  _G.to_send=nil
end)
  