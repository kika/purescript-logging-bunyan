## Module Logging.Bunyan

#### `LogLevel`

``` purescript
data LogLevel
  = Fatal
  | Error
  | Warning
  | Info
  | Debug
  | Trace
```

#### `logLevelName`

``` purescript
logLevelName :: LogLevel -> LogLevelName
```

#### `LOG`

``` purescript
data LOG :: !
```

Effect type for logging

#### `Logger`

``` purescript
data Logger :: *
```

Logger instance

#### `BunyanOpts`

``` purescript
data BunyanOpts :: *
```

Phantom type for Options

#### `logOptName`

``` purescript
logOptName :: Option BunyanOpts String
```

`create` options

#### `create`

``` purescript
create :: Options BunyanOpts -> Logger
```

Creates a logger instance based on Bunyan options passed

#### `Variadic`

``` purescript
class Variadic a where
  vararg' :: Array String -> a
```

##### Instances
``` purescript
Variadic String
(Show a, Variadic v) => Variadic (a -> v)
```

#### `LogRecord`

``` purescript
newtype LogRecord
```

##### Instances
``` purescript
Show LogRecord
```

#### `logR`

``` purescript
logR :: forall r. {  | r } -> LogRecord
```

Helper function to support output of records to the log
takes an arbitrary record and returns `LogRecord`

#### `logF`

``` purescript
logF :: forall v. Variadic v => v
```

Accepts a variable number of arguments of variable type 
and returns a string suitable for logging

#### `fatal`

``` purescript
fatal :: forall e. Logger -> String -> Eff (log :: LOG | e) Unit
```

#### `error`

``` purescript
error :: forall e. Logger -> String -> Eff (log :: LOG | e) Unit
```

#### `warn`

``` purescript
warn :: forall e. Logger -> String -> Eff (log :: LOG | e) Unit
```

#### `info`

``` purescript
info :: forall e. Logger -> String -> Eff (log :: LOG | e) Unit
```

#### `debug`

``` purescript
debug :: forall e. Logger -> String -> Eff (log :: LOG | e) Unit
```

#### `trace`

``` purescript
trace :: forall e. Logger -> String -> Eff (log :: LOG | e) Unit
```

#### `getLevel`

``` purescript
getLevel :: Logger -> LogLevel
```

Gets current logging level

#### `setLevel`

``` purescript
setLevel :: forall e. Logger -> LogLevel -> Eff (log :: LOG | e) Logger
```

Sets logging level and returns updated logger.


