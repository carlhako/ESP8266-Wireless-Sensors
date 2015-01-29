# ESP8266-Wireless-Sensors
The ESP8266's make awesome wireless sensors for around your house. This repository contains a nodejs server for receiving and storing sensor readings. The nodejs service also hosts a webpage for displaying your charted data via highcharts. Included is LUA code for the ESP8266 modules to read from various sensors and submit the data to the nodejs proccess.

Required:
Nodejs
Mysql server
nodemcu install on esp8266

I have just done an inital sync of my currently working code. Work is in progress on making this easier for someone else to use. If you find this repository and are having a go at getting it running create an issue if you need some help.

# To Do
- cleanup and comment all code
- db checking, can user login, does table exist, does the user have write access
- init.lua for esp-03/esp-12 with GPIO 16 accessable to put the esp into deep sleep between readings
- document setup process
- document how to start nodejs process on linux bootup (currently my issue)
