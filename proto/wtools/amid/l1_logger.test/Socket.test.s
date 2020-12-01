( function _Socket_test_s( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( './../../../wtools/Tools.s' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );

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

function SocketServerOpenWithModuleWebsocket( test )
{
  test.case = 'basic';
  test.true( 1 );
}

//

function SocketServerOpenWithModuleWs( test )
{
  test.case = 'basic';
  test.true( 1 );
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
    SocketServerOpenWithModuleWebsocket,
    SocketServerOpenWithModuleWs,
  }

}

_.mapExtend( Self, Proto );

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self )

})();
