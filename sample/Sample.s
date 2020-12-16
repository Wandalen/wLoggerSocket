
let LoggerSocket = require( 'wloggersocket' );

/**/

var loggerSocket = new LoggerSocket();
loggerSocket.outputTo( console );
console.log( `Listening "${loggerSocket.serverPath}" ...` );
