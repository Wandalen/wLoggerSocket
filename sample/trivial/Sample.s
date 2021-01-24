
let LoggerSocket = require( 'wloggersocket' );

/**/

let loggerSocket = new LoggerSocket();
loggerSocket.outputTo( console );
console.log( `Listening "${loggerSocket.serverPath}" ...` );
