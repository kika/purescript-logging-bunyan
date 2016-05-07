module Node.Logging.Bunyan 
(
    BUNYAN()
  , create
  , info
  {-
  , trace
  , debug
  , warn
  , error
  , fatal
  -}
)
where

import Prelude (Unit)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

-- | Effect type for logging
foreign import data BUNYAN :: !

-- | Logger instance
foreign import data Logger :: * -> *


