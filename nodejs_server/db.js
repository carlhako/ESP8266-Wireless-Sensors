var mysql = require('mysql');

// update with your mysql username/password below
var pool  = mysql.createPool({
  connectionLimit : 5,
  host            : '192.168.1.8',
  user            : 'carl',
  password        : 'asdf'
});

var db = {};

db.onLoad = function(){
	// check for database and table
	// create if doesnt exist
	// create code
	/*
CREATE TABLE `dump` (
	`id` INT(10) NOT NULL AUTO_INCREMENT,
	`date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
	`location` VARCHAR(20) NOT NULL COLLATE 'utf8_bin',
	`temp` DECIMAL(4,2) NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `location` (`location`),
	INDEX `date` (`date`)
)
COLLATE='utf8_bin'
ENGINE=InnoDB
AUTO_INCREMENT=4235;
*/
}

// this will create a pool connection or use an empty pool connection, run the query and run the callback function with returned rows from mysql
db.q = function(query,cb){
	pool.getConnection(function(err, connection) {
		if (!err) {
			connection.query(query, function(err, rows) {
				if (!err) { 
					if (typeof cb !== "undefined") { 
						cb(rows); 
					}
					connection.destroy(); // change to connection.release() if you have lots of sensors like 100
				} 
				else { console.log('query error'); }
			})
		} else { console.log('pool failed to get connection'); }
	});
}

module.exports = db;