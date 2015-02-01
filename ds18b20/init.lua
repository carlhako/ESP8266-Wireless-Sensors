--init.lua
print("Setting up WIFI...")
wifi.setmode(wifi.STATION)
wifi.sta.config("SSID","KEY")
wifi.sta.connect()

tmr.alarm(0, 1000, 1, function() 
	if wifi.sta.getip()== nil then 
		print("IP unavaiable, Waiting...") 
	else 
		tmr.stop(0)
		print("Config done, IP is "..wifi.sta.getip())
		t = require("ds18b20")
		t.setup(4)
		addrs = t.addrs()
		if (addrs ~= nil) then
			  if (table.getn(addrs) > 0) then
				print("Total DS18B20 sensors: "..table.getn(addrs))
				-- do a couple of startup temp reads, first one is generaly wrong (85)
				print("Temp: "..t.read())
				print("Temp: "..t.read())
				getSleepDelay()
			else
				print('No temp sensors found')
			end
		end
	end
end)

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
		conn=net.createConnection(net.TCP, 0)
		conn:connect(5050,'192.168.1.8') 
		local temp = t.read()
		conn:send("add|"..temp.."|garage\n")
		print('sending temp '..temp)
		conn:on("sent",function(conn)
			conn:close()
		end)
		conn:on("disconnection", function(conn)
			getSleepDelay()
		end)
	end)
end
