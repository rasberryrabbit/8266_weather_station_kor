# 8266_weather_station_kor  
한국 기상청의 RSS 서비스로 날씨예보를 가져오는 간단한 날씨 표시기입니다.  
  
weconfig.lua 파일에 지역코드를 입력해야 데이터를 가져올 수 있습니다. 
  
ESP8266과 0.96인치 I2C OLED 디스플레이로 만들어졌습니다.  
데이터를 가져오기 위해 인터넷 연결이 필요합니다.
  
전선연결 
SDA -> 8266 D1, SCL -> 8266 D2, VCC -> 3.3v, GND -> GND  
  
eus_params.lua 파일을 생성하면 바로 와이파이 연결환경을 만들 수 있습니다.
```
local p={}
p.wifi_ssid="SSID"
p.wifi_password="비번"
return p
```
