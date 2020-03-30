(function _Websocket_s_() {

'use strict';

/**
 * Inherit class Logger, extending it to receive data from websocket.
  @module Tools/mid/logger/WebsocketReceiver
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );

  _.include( 'wLogger' );
  _.include( 'wUriBasic' );

}

var _global = _global_;
var _ = _global_.wTools;
var Parent = _.PrinterTop;
var Self = function wLoggerSocketReceiver( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'LoggerSocketReceiver';

// --
// routines
// --

function finit()
{
  var self = this;
  self.unform();
  Parent.prototype.finit.call( self );
}

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self, o );
}

//

function unform()
{
  var self = this;

  if( self.socketServer )
  {
    if( self.owningSocketServer )
    self.socketServer.shutDown();
    self.socketServer = null;
  }

  if( self.httpServer )
  {
    if( self.owningHttpServer )
    self.httpServer.close();
    self.httpServer = null;
  }

}

//

function form()
{
  var self = this;

  if( _.strIs( self.serverPath ) )
  self.serverPath = _.uri.parse( self.serverPath );

  _.assert( _.longHas( [ 'ws', 'wss' ], self.serverPath.protocol ), `Unsupported protocol ${self.serverPath.protocol}` );

  let opts =
  {
    httpServer : self.httpServer,
    socketServer : self.socketServer,
    serverPath : self.serverPath,
    onReceive,
  }

  self.SocketServerOpen( opts );
  _.mapExtend( self, _.mapBut( opts, [ 'onReceive' ] ) );

  function onReceive( op )
  {
    _.assert( _.routineIs( self[ op.data.methodName ] ), `Unknown method ${op.data.methodName}` );
    self[ op.data.methodName ].apply( self, op.data.args );
  }

}

//

function SocketServerOpen( o )
{

  _.routineOptions( SocketServerOpen, arguments );

  let WebSocketServer = require( 'websocket' ).server;
  let Http = require( 'http' );

  if( _.strIs( o.serverPath ) )
  o.serverPath = _.uri.parse( o.serverPath );

  if( !o.httpServer )
  {
    if( !o.serverPath.port )
    o.serverPath.port = 80;
    o.httpServer = Http.createServer( function( request, response, next )
    {
      debugger;
    });
    o.httpServer.listen( o.port, function() { } );
  }

  if( o.socketServer === null )
  o.socketServer = new WebSocketServer
  ({
    httpServer : o.httpServer,
    autoAcceptConnections : false,
  });

  o.socketServer.on( 'close', function()
  {
  });

  o.socketServer.on( 'connect', function()
  {
  });

  o.socketServer.on( 'request', function( request )
  {

    if( request.resource !== o.serverPath.resourcePath )
    return request.reject();

    if( 0 )
    return request.reject();

    var connection = request.accept( null, request.origin );

    connection.on( 'message', function( message )
    {
      _.assert( message.type === 'utf8' );
      let parsed = JSON.parse( message.utf8Data );
      if( o.onReceive )
      o.onReceive({ data : parsed });
    });

    connection.on( 'close', function( connection )
    {
    });

  });

}

SocketServerOpen.defaults =
{
  httpServer : null,
  socketServer : null,
  serverPath : null,
  onReceive : null,
}

// --
// relations
// --

var Composes =
{

}

var Aggregates =
{
  httpServer : null,
  owningHttpServer : 1,
  socketServer : null,
  owningSocketServer : 1,
  serverPath : 'ws://127.0.0.1:5000/log/',
}

var Associates =
{
}

var Statics =
{
  SocketServerOpen,
}

// --
// prototype
// --

var Proto =
{

  finit,
  init,
  unform,
  form,

  SocketServerOpen,

  Composes,
  Aggregates,
  Associates,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
