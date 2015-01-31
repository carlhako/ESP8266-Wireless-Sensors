# ESP8266-Wireless-Sensors
The ESP8266's make awesome wireless sensors for around your house. This repository contains a nodejs server for receiving and storing sensor readings. The nodejs service also hosts a webpage for displaying your charted data via highcharts. Included is LUA code for the ESP8266 modules to read from various sensors and submit the data to the nodejs proccess.

Required:
Nodejs
Mysql server
nodemcu install on esp8266

I have just done an inital sync of my currently working code. Work is in progress on making this easier for someone else to use. If you find this repository and are having a go at getting it running create an issue if you need some help.

How it works
------------
1. ESP8266 takes a reading from its attached sensor
2. ESP8266 creates a TCP connection to the nodejs service
3. Sensor data is sent to the nodejs service via the tcp connection. Raw data is sent via the socket instead of using web requests to simplify this.
4. Nodejs service confirms the data is valid and inserts the data into a mysql database
5. ESP8266 sends a second request to the nodejs service asking how long until next reading is required. This ESP either sets a timer or goes into sleep mode until the next reading is required. This eliminates the need for each ESP sensor to keep the time and the intervals are set in one place on the nodejs service.

# To Do
- cleanup and comment all code
- db checking, can user login, does table exist, does the user have write access
- init.lua for esp-03/esp-12 with GPIO 16 accessable to put the esp into deep sleep between readings
- document setup process
- document how to start nodejs process on linux bootup (currently my issue)
- add in support for mongodb
- per sensor interval settings
- ability to change the sensors location from a configuration page as part of the nodejs service. Ability to move a sensor to somewhere else without having to upload a new LUA file just to change the name that goes into the database as its location.
