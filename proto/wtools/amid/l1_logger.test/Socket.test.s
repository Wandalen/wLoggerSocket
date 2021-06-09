( function _Socket_test_s( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( './../../../node_modules/Tools' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );
  _.include( 'wConsequence' );

  require( './../l1_logger/Socket.s' );

}

const _global = _global_;
const _ = _global_.wTools;

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
    let middleLogger = new _.Logger({ onWriteEnd });
    loggerSocket.form();
    loggerSocket.outputTo( middleLogger );
    test.true( _.printerIs( loggerSocket ) );

    ws = new WebSocket( 'ws://127.0.0.1:15000' );
    ws.on( 'open', function open()
    {
      ws.send( JSON.stringify({ methodName : 'log', args : [ 'text1', 'text2' ] }) );
    });

    return _.time.out( 1000 );
  })

  ready.then( () =>
  {
    test.identical( track, [ 'end : text1 text2' ] );
    loggerSocket.finit();
    ws.close();
    return null;
  })

  return ready;

  /* - */

  function onWriteEnd( o )
  {
    track.push( 'end' + ' : ' + o.input[ 0 ] );
    return o;
  }
}

//

const Proto =
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

// _.props.extend( Self, Proto );

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self )

})();
