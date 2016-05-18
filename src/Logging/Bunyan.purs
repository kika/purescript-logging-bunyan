module Logging.Bunyan 
(
    LOG
  , Logger
  , BunyanOpts
  , LogLevel
  , LogRecord
  , class Variadic
  , vararg'
  , logF
  , logR
  , create
  , fatal
  , error
  , warn
  , info
  , debug
  , trace
  , LogLevel(..)
  , getLevel
  , setLevel
  , logLevelName
  , logOptName
)
where

import Prelude (Unit, ($), class Show, (++), show, (<<<) )
import Control.Monad.Eff (Eff)
import Data.Options (Options(), Option(), opt, options)
import Data.Function (Fn3, Fn2, Fn1, runFn3, runFn2, runFn1)
import Data.Foreign (Foreign)
import Data.String (joinWith)
import Data.ExistsR (ExistsR, mkExistsR)

data LogLevel = 
  Fatal   | 
  Error   | 
  Warning | 
  Info    | 
  Debug   | 
  Trace
type LogLevelName = String
logLevelName:: LogLevel -> LogLevelName
logLevelName Fatal   = "fatal"
logLevelName Error   = "error"
logLevelName Warning = "warn"
logLevelName Info    = "info"
logLevelName Debug   = "debug"
logLevelName Trace   = "trace"
logLevelFromName::String -> LogLevel
logLevelFromName "fatal"  = Fatal
logLevelFromName "error"  = Error
logLevelFromName "warn"   = Warning
logLevelFromName "info"   = Info
logLevelFromName "debug"  = Debug
logLevelFromName "trace"  = Trace
logLevelFromName "trace"  = Trace
logLevelFromName _        = Trace -- Catch'all

-- | Effect type for logging
foreign import data LOG :: !

-- | Logger instance
foreign import data Logger :: *

-- Foreign implementations
foreign import createLoggerImpl::Fn1 Foreign Logger
foreign import 
  logImpl::forall e. Fn3 LogLevelName Logger String (Eff (log::LOG|e) Unit) 
foreign import getLogLevelImpl::Fn1 Logger LogLevelName
foreign import setLogLevelImpl::Fn2 Logger LogLevelName Logger

-- | Phantom type for Options
foreign import data BunyanOpts :: *

-- | `create` options
logOptName::Option BunyanOpts String
logOptName = opt "name"
logOptLevel::Option BunyanOpts LogLevelName
logOptLevel = opt "level"

-- | Creates a logger instance based on Bunyan options passed
create::Options BunyanOpts -> Logger
create opts = runFn1 createLoggerImpl $ options opts

class Variadic a where 
  vararg'::Array String -> a
instance varargStr::Variadic String where
  vararg' acc = joinWith " " acc
instance varargArg::(Show a, Variadic v) => Variadic (a -> v) where
  vararg' acc = \x -> vararg' (acc ++ [show x])

{- Machinery to support output of arbitrary records -}
-- newtype wrapper to overcome orphaned instances limitation
newtype LogRecord = LogRecord (ExistsR Object)
instance showRecord::Show LogRecord where
  show (LogRecord r) = showRecordImpl r
foreign import showRecordImpl::ExistsR Object -> String

-- | Helper function to support output of records to the log
-- | takes an arbitrary record and returns `LogRecord`
logR::forall r. {|r} -> LogRecord
logR = LogRecord<<<mkExistsR

-- | Accepts a variable number of arguments of variable type 
-- | and returns a string suitable for logging
logF::forall v. (Variadic v) => v
logF = vararg' []

fatal:: forall e. Logger -> String -> Eff(log::LOG|e) Unit
fatal logger msg = runFn3 logImpl (logLevelName Fatal) logger msg

error:: forall e. Logger -> String -> Eff(log::LOG|e) Unit
error logger msg = runFn3 logImpl (logLevelName Error) logger msg

warn:: forall e. Logger -> String -> Eff(log::LOG|e) Unit
warn logger msg = runFn3 logImpl (logLevelName Warning) logger msg

info:: forall e. Logger -> String -> Eff(log::LOG|e) Unit
info logger msg = runFn3 logImpl (logLevelName Info) logger msg

debug:: forall e. Logger -> String -> Eff(log::LOG|e) Unit
debug logger msg = runFn3 logImpl (logLevelName Debug) logger msg

trace:: forall e. Logger -> String -> Eff(log::LOG|e) Unit
trace logger msg = runFn3 logImpl (logLevelName Trace) logger msg

-- | Gets current logging level
getLevel::Logger -> LogLevel
getLevel logger = logLevelFromName $ runFn1 getLogLevelImpl logger

-- | Sets logging level and returns new logger. Old logger is no longer valid
setLevel::Logger -> LogLevel -> Logger
setLevel logger level = runFn2 setLogLevelImpl logger $ logLevelName level
