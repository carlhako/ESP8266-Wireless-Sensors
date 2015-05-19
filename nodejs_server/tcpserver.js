var _ = require('underscore');
var db = require('./db');
var moment = require('moment');
net = require('net');

var tcpserver = {};

// create tcp connection
net.createServer(function (socket) {
	console.log('connection from: '+socket.remoteAddress + ":" + socket.remotePort );
	// listen for incoming data
	socket.on('data', function (data) {
		var msg = data.toString();
		// some work required here to handle multiple readings in one connection
		msg = msg.trim(); // trim off any \n coming in 
		console.log(moment().format('DD/MM/YY HH:mm:ss')+' message received: '+msg);
		if (/&&/.test(msg)) msg = msg.split(/&&/); // this was a quick fix to allow 2 readings in one line of data, separated with &&
		if (typeof msg === "object") _.each(msg,function(m){ tcpserver.processMessage(m,socket); });
		else { tcpserver.processMessage(msg,socket); }
	});

	// listen for connections dropped 
  socket.on('end', function () {
    console.log('tcp connection dropped');
  });
}).listen(5050);

// this function accepts a line of data come in via tcp connection, the first part of the string determins what is done with it.
tcpserver.processMessage = function(msg,socket){
	msg = msg.trim();
	var req = msg.split(/\|/);
	switch (req[0]) {
		case 'add':  // split the string into seperate values, run a mysql insert query.
			if (/\d+\.\d+/.test(req[1]) && /\w+/.test(req[2])) { // simple data validation
				var query = "INSERT INTO temps.dump (temp,location) VALUES ('"+req[1]+"','"+req[2]+"')";
				db.q(query);
			}
		break;
		case 'sleepdelay': // return number of seconds until next update is required.
			var delay = (Math.floor(moment().format('mm')/15+1)*15-moment().format('mm'))*60-moment().format('ss');
			socket.write(delay.toString());
			console.log('sent back: '+delay);
		break;
	};
}
 
console.log("TCP server running on port 5050\n");