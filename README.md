# colon_rocket
*puts a Ruby Hash to your shell as a valid JSON object (without hash rockets)*


*note: always returns `nil`*

___

```
require 'colon_rocket'
ColonRocket.blastoff(hash, allow_overwrite)
```

![Example](https://i.imgur.com/booOeGW.png)

#### *Conflicting Keys*
- default raises overlapping keys exception
```
  ColonRocket::OverlappingKeysException
  (Collision detected, identical key found as String and Symbol, example { a: "B", "a" => "NOT B" } 
```
