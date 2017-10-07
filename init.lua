--Change the SSID and the SSPWD base on your router

--Values to be changed
------------------------------------
ssid="SSID NAME"
sspwd="SSID PASSWORD"
------------------------------------
--Also replace "YOURDEVICEIDHERE" below with your device ID


--set the GPIO pins Mode
gpio.mode(2, gpio.INPUT)
gpio.mode(1, gpio.OUTPUT)
gpio.mode(0, gpio.INPUT)
gpio.mode(5, gpio.OUTPUT)
gpio.mode(6, gpio.INPUT)
gpio.mode(7, gpio.OUTPUT)

--Variables
c1=9
c2=9
c3=9
s1=9
s2=9
s3=9
a1=9

--set the WIFI Mode
wifi.setmode(wifi.STATIONAP)
wifi.setmode(wifi.STATION)
wifi.sta.config(ssid,sspwd)

function internet()
--print("Test1 Here")
tmr.wdclr()
readstatus()
conn=net.createConnection(net.TCP, 0)
    conn:on("connection",function(conn, payload)
    conn:send("GET /account/diy_cmd_sts.php?id=YOURDEVICEIDHERE&uid=232&c1="..(c1).."&s1="..(s1)..
                "&c2="..(c2).."&s2="..(s2).."&c3="..(c3).."&s3="..(s3).."&a1="..(a1).."&a2=1&a3=1"..
                " HTTP/1.1\r\n".. 
                "Host: iot-ph.com\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
            end)
    conn:on("receive", function(conn, payload)
        conn:close()
        print(payload)
        if(payload==nil) then
        payload1="cmd1=9cmd2=9cmd3=9"
        else
        payload1=payload
        end
        payload=""
        execute()
    end)
    conn:connect(80,'iot-ph.com')
    tmr.alarm(1,5000,1,internet)
end

function execute()
c1=(string.sub(payload1,string.find(payload1,"cmd1=")
    +5,string.find(payload1,"cmd1=")+5))
c2=(string.sub(payload1,string.find(payload1,"cmd2=")
    +5,string.find(payload1,"cmd2=")+5))
c3=(string.sub(payload1,string.find(payload1,"cmd3=")
    +5,string.find(payload1,"cmd3=")+5)) 
heap=node.heap()
print("heap="..heap)
a1=adc.read(0)+1
print("ADC="..a1)
if(c1 == "2")then
    gpio.write(2, gpio.HIGH);
elseif(c1 == "1")then
    gpio.write(2, gpio.LOW);
    end
if(c2 == "2")then
    gpio.write(0, gpio.HIGH);
elseif(c2 == "1")then
    gpio.write(0, gpio.LOW);
    end
if(c3 == "2")then
    gpio.write(6, gpio.HIGH);
elseif(c3 == "1")then
    gpio.write(6, gpio.LOW);
    end
end

function readstatus()
s1 = gpio.read(1) + 1
s2 = gpio.read(5) + 1
s3 = gpio.read(7) + 1
end
internet()