# colon_rocket
*puts a Ruby Hash to your shell as a valid JSON object (without hash rockets)*

___

```
require colon_rocket
ColonRocket.blastoff(hash, allow_overwrite)
```

![Example](https://i.imgur.com/booOeGW.png)

#### *Conflicting Keys*
- default raises overlapping keys exception
```
  ColonRocket::OverlappingKeysException 
  (Collision detected, identical key found as String and Symbol, example { a: "B", "a" => "NOT B" } 
  Pass in a second argument of true (boolean) to overwrite to the final positional value)
```
- allow overwriting by passing in true as second argument
  - will set value as final assigment based on position
  - will notify of reassignment "Collision detected..." (can silence by passing in false as third argument)
![Allow Conflicting Keys](https://i.imgur.com/iao3NFB.png)
