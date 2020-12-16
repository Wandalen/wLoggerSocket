const { time } = require('console');

( function _Socket_test_s( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( './../../../wtools/Tools.s' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );
  _.include( 'wConsequence' );

  require( './../l1_logger/Socket.s' );

}

let _global = _global_;
let _ = _global_.wTools;
let Self = {};

// --
// context
// --

function suiteBegin()
{
  let context = this;
  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'Socket' );
}

//

function suiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, '/Socket-' ) )
  _.path.tempClose( context.suiteTempPath );
}

// --
// Tests
// --

function basic( test )
{
  const WebSocket = require( 'ws' );
  const Http = require( 'http' );
  let track = [];
  let ws = null;
  let ready = new _.Consequence().take( null );
  let loggerSocket = new _.LoggerSocketReceiver
  ({
    httpServer : null,
    owningHttpServer : 1,
    serverPath : 'ws://127.0.0.1:15000/.log/',
  });

  ready.then( () =>
  {
    test.case = 'basic';
    let middleLogger = new _.Logger({ onTransformBegin });
    loggerSocket.form();
    loggerSocket.outputTo( middleLogger );
    test.true( _.printerIs( loggerSocket ) );
  
    ws = new WebSocket( 'ws://127.0.0.1:15000' );
    ws.on( 'open', function open()
    {
      ws.send( JSON.stringify( { methodName : 'log', args : [ 'text1', 'text2' ] } ) );
    });

    return _.time.out( 1000 );
  })

  ready.then( () =>
  {
    test.identical( track, [ 'begin : text1 text2' ] );
    loggerSocket.finit();
    ws.close();
    return null;
  })

  return ready;

  /* - */

  function onTransformBegin( o )
  {
    track.push( 'begin' + ' : '  + o.input[ 0 ] );
    return o;
  }
}

//

var Proto =
{

  name : 'Tools.l1.Socket',
  silencing : 1,
  routineTimeOut : 60000,
  onSuiteBegin : suiteBegin,
  onSuiteEnd : suiteEnd,

  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
  },

  tests :
  {
    basic
  }

}

_.mapExtend( Self, Proto );

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self )

})();
