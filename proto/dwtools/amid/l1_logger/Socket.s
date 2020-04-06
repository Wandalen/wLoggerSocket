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

let _global = _global_;
let _ = _global_.wTools;
let Parent = _.PrinterTop;
let Self = function wLoggerSocketReceiver( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'LoggerSocketReceiver';

// --
// routines
// --

function finit()
{
  let self = this;
  self.unform();
  Parent.prototype.finit.call( self );
}

//

function init( o )
{
  let self = this;
  Parent.prototype.init.call( self, o );
}

//

function unform()
{
  let self = this;

  self._unforming = 1;

  if( self.socketServer )
  {
    if( self.owningSocketServer )
    {
      if( _.routineIs( self.socketServer.shutDown ) )
      self.socketServer.shutDown();
      else
      self.socketServer.close();
    }
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
  let self = this;

  _.assert( self._que === null );

  self._que = [];

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

  self.SocketServerOpenWithModuleWebsocket( opts );
  // self.SocketServerOpenWithModuleWs( opts );
  _.mapExtend( self, _.mapBut( opts, [ 'onReceive' ] ) );

  /* */

  function onReceive( op )
  {
    _.assert( _.routineIs( self[ op.structure.methodName ] ), `Unknown logger method ${op.structure.methodName}` );

    // op.structure.serverTime = _.time.now();
    // self._que.push( op );
    //
    // if( self._queTimer === null )
    // self._queRun();

    self[ op.structure.methodName ].apply( self, op.structure.args );

  }

  /* */

}

//

function _queRun()
{
  let self = this;

  _.assert( self._que !== null );
  _.assert( self._queTimer === null );
  _.assert( self._queTime === null );
  _.assert( arguments.length === 0 );

  if( self._unforming )
  return;

  self._queContinue();
}

//

function _queContinue()
{
  let self = this;

  _.assert( self._que !== null );
  _.assert( self._queTimer === null );
  _.assert( arguments.length === 0 );

  if( self._unforming )
  return self._queStopEnd();
  if( !self._que.length )
  return self._queStopEnd();

  self._queTime = _.time.now();
  self._queTimer = _.time.begin( self.period, () => self._queTimeEnd() );

}

//

function _queStopEnd()
{
  let self = this;
  if( self._queTimer )
  self._queTimer = null;
  if( self._queTime )
  self._queTime = null;
}

//

function _queTimeEnd()
{
  let self = this;

  _.assert( arguments.length === 0 );

  self._queTimer = null;
  self._queLog( self._que, _.time.now() - self.period / 2 );
  self._queContinue();

}

//

function _queLog( que, beforeTime )
{
  let self = this;
  let subjects = Object.create( null );

  _.assert( arguments.length === 2 );

  for( let i = 0 ; i < que.length ; i++ )
  {
    let op = que[ i ];
    let subjectArray = subjects[ op.structure.subject ] = subjects[ op.structure.subject ] || [];
    subjectArray.push( op );
  }

  for( let subject in subjects )
  {
    let que2 = subjects[ subject ];
    que2.sort( ( a, b ) => a.structure.id - b.structure.id );
    while( que2.length )
    {
      let op = que2[ 0 ];
      if( op.structure.serverTime > beforeTime )
      break;
      que2.splice( 0, 1 );
      _.arrayRemoveOnce( que, op );
      self[ op.structure.methodName ].apply( self, op.structure.args );
    }
  }

}

//

function SocketServerOpenWithModuleWebsocket( o )
{

  _.routineOptions( SocketServerOpenWithModuleWebsocket, arguments );

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

    let connection = request.accept( null, request.origin );

    connection.on( 'message', function( message )
    {
      _.assert( message.type === 'utf8' );
      let parsed = JSON.parse( message.utf8Data );
      if( o.onReceive )
      o.onReceive({ structure : parsed });
    });

    connection.on( 'close', function( connection )
    {
    });

  });

}

SocketServerOpenWithModuleWebsocket.defaults =
{
  httpServer : null,
  socketServer : null,
  serverPath : null,
  onReceive : null,
}

//

function SocketServerOpenWithModuleWs( o )
{

  _.routineOptions( SocketServerOpenWithModuleWs, arguments );

  let Ws = require( 'ws' );
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
    o.httpServer.listen( o.port, function() {} );
  }

  if( o.socketServer === null )
  o.socketServer = new Ws.Server
  ({
    clientTracking : false,
    noServer : true,
  });

  o.httpServer.on( 'upgrade', function( request, socket, head )
  {
    o.socketServer.handleUpgrade( request, socket, head, function( connection )
    {
      o.socketServer.emit( 'connection', connection, request );
    });
  });

  o.socketServer.on( 'connection', function( connection, request )
  {

    connection.on( 'message', function( message )
    {
      let parsed = JSON.parse( message );
      if( o.onReceive )
      o.onReceive({ structure : parsed });
    });

    connection.on( 'close', function( connection )
    {
    });

  });

}

SocketServerOpenWithModuleWs.defaults =
{
  httpServer : null,
  socketServer : null,
  serverPath : null,
  onReceive : null,
}

// --
// relations
// --

let Composes =
{

}

let Aggregates =
{
  httpServer : null,
  owningHttpServer : 1,
  socketServer : null,
  owningSocketServer : 1,
  period : 200,
  serverPath : 'ws://127.0.0.1:25000/log/',
}

let Associates =
{
}

let Restricts =
{

  _que : null,
  _queTime : null,
  _queTimer : null,
  _unforming : 0,

}

let Statics =
{
  SocketServerOpenWithModuleWebsocket,
  SocketServerOpenWithModuleWs,
}

// --
// prototype
// --

let Proto =
{

  finit,
  init,
  unform,
  form,

  _queRun,
  _queContinue,
  _queStopEnd,
  _queTimeEnd,
  _queLog,

  SocketServerOpenWithModuleWebsocket,
  SocketServerOpenWithModuleWs,

  Composes,
  Aggregates,
  Associates,
  Restricts,
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
