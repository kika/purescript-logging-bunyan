module Logging.Bunyan 
(
    LOG()
  , Logger()
  , BunyanOpts()
  , class Log
  , create
  , info
  , name
)
where

import Prelude (Unit, ($))
import Control.Monad.Eff (Eff)
-- import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Options (Options(), Option(), opt, options)
import Data.Function (Fn2, Fn1, runFn2, runFn1)
import Data.Foreign (Foreign)

-- | Effect type for logging
foreign import data LOG :: !

-- | Logger instance
foreign import data Logger :: *

-- Foreign implementations
foreign import createLoggerImpl::Fn1 Foreign Logger
foreign import infoImpl:: 
-- WHY???  forall a eff. (Log a) => Fn2 Logger a (Eff (log :: LOG | eff) Unit) 
  forall a eff. Fn2 Logger a (Eff (log :: LOG | eff) Unit) 

-- | Phantom type for Options
foreign import data BunyanOpts :: *

-- | `create` options
name::Option BunyanOpts String
name = opt "name"

-- | Creates a logger instance based on Bunyan options passed
create::Options BunyanOpts -> Logger
create opts = runFn1 createLoggerImpl $ options opts

class Log entry where
  info::forall e. Logger -> entry -> Eff (log :: LOG | e) Unit

instance infoString::Log String where
  info logger msg = runFn2 infoImpl logger msg
instance infoChar::Log Char where
  info logger msg = runFn2 infoImpl logger msg
instance infoInt::Log Int where
  info logger msg = runFn2 infoImpl logger msg
instance infoNumber::Log Number where
  info logger msg = runFn2 infoImpl logger msg
