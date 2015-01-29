print("Setting up WIFI...")
wifi.setmode(wifi.STATION)
wifi.sta.config("ACHome","0400051283")
wifi.sta.connect()

tmr.alarm(0, 1000, 1, function() 
	if wifi.sta.getip()== nil then 
		print("IP unavaiable, Waiting...") 
	else 
		tmr.stop(0)
		print("Config done, IP is "..wifi.sta.getip())
		h = require("dht22")
		getSleepDelay()
	end
end)

function sendUpdate()
	-- first get fresh readings
	h.read(3)
	local temp = h.getTemperature()
	temp = (temp/10)..'.'..(temp%10)
	local hum = h.getHumidity()
	hum = (hum/10)..'.'..(hum%10)
	-- now make a tcp connection to the nodejs service
	conn=net.createConnection(net.TCP, 0)
	conn:connect(5050,'192.168.1.8') 
	print('sending humidity'..hum)
	conn:send("add|"..hum.."|powerboxhumidity&&add|"..temp.."|powerboxtemperature\n")
	print('sending temp'..temp)
	conn:send("")
	conn:on("sent",function(conn)
		conn:close()
	end)
	conn:on("disconnection", function(conn)
		getSleepDelay()
	end)
end

function getSleepDelay()
	tmr.alarm(1,60000,1,function()
		print('Attempting to get delay till next update required')
		conn=net.createConnection(net.TCP, 0)
		conn:connect(5050,'192.168.1.8') 
		conn:send("sleepdelay\n")
		conn:on("receive", function(sck, c)
			tmr.stop(1)
			nextUpdate(c)
			conn:close()
		end)
		conn:on("reconnection",function() print('reconnect trying to get sleep delay') end )
	end)
end

function nextUpdate(seconds)
	print('next update will be done in '..(seconds*1000)..' seconds')
	tmr.alarm(2, seconds*1000, 0, function()
		sendUpdate()
	end)
end