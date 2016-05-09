module Test.Main where

import Prelude (Unit, bind)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Options (Options(), (:=))

import Logging.Bunyan (LOG(), BunyanOpts(), name, create, info)

logOpts :: Options BunyanOpts
logOpts = name := "Test"

main :: forall e. Eff (console :: CONSOLE, log :: LOG | e) Unit
main = do
  let logger = create logOpts
  info logger "First log entry"
  info logger 10
  info logger 100.99
  log "You should add some tests."
