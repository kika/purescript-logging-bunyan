module Test.Main where

import Prelude (Unit, bind, ($))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Options (Options(), (:=))

import Logging.Bunyan (
    LOG, BunyanOpts, 
    logF, logOptName, logR, 
    create, fatal, error, warn, info, debug, trace, 
    getLevel, setLevel, logLevelName,
    LogLevel (Fatal, Error, Warning, Info, Debug, Trace)
  )

logOpts :: Options BunyanOpts
logOpts = logOptName := "Test"

main :: forall e. Eff (console::CONSOLE, log::LOG | e) Unit
main = do
  -- Default log level is Info
  let logger = create logOpts
  info logger $ logF "First log entry"
  info logger $ logF 10
  info logger $ logF 100.99
  info logger $ logF "Variable types:"
    " Record = " (logR{fname: "John", lname:"Doe"})
    " String = " "test string"
    " Int = "  99
    " Num = "  10.11
  fatal logger "Fatal error - ignore!"
  error logger "Error - ignore!"
  warn  logger "Warning - actually, not"
  info  logger "Info - this one is true"
  debug logger "Debug - if you see this, it's an error"
  trace logger "Trace - you should not see this either"
  info  logger $ logF "Log level is: " $ logLevelName $ getLevel logger
  debug logger "Debug - if you see this, it's an error"
  trace logger "Trace - you should not see this either"
  setLevel logger Trace
  debug logger "Debug - you should see this"
  trace logger "Trace - and you should see this too"
