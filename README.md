# purescript-logging-bunyan
Purescript bindings to Bunyan logging framework (Node and browser)

## Implements a minimal necessary subset of Bunyan API

Supports logging of arbitrary records:
```"Variable types:" " Record = " { fname: 'John', lname: 'Doe' } " String = " "test string" " Int = " 99 " Num = " 10.11```

See example in [test/Main.purs](test/Main.purs)

If you want to see nicely formatted log with blackjack and colors, install
bunyan globally: `npm install -g bunyan` and filter the log through the `bunyan`
utility:

`pulp test | bunyan`

