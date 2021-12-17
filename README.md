# MINI MAPPLE

This project aims to reproduce basic features of a CAS like Mapple.


## Minimal set of commands to implement
* storing an integer in a variable: `$i = 3` and displaying it back when the user just type it.
* storing a sum in a variable: `$s = (3 + 4)` display the sum back when the user types this variable. E.g.
  if the user types `$s` we want to see `(3+4)`, not `7`.
  *Note: to simplify parsing, all the operations will be surrounded with parenthesis*.
* add expression evaluation: `eval($s)` would display `7`.
* add support for unknown: `$t = (3 + x)`. Note that the unknown doesn't have a `$` sign in front of it.
* support nested expression: `$u = ((x+8) + (4 + 5))`.
* extend the `eval` command to accept a list of assignations: `eval($t, x=5)` would display `8`. 
  If we try evaluating an expression with a unknown which doesn't have value, we reduce the expression as much
  as we can, leaving the unknown unevaluated. E.g., if `$r = (x + (5 + y))`, `eval($r, y=2)` would display `(x+7)`.
* support all binary operators: `+, *, -, /`.





## Additional optional features
* make it possible to use a variable like `$s` as a normal expression. E.g. we could be able to write: `$s = (5 + x)`
  and then `eval((3 + $s), x = 9)`.
* simplify expressions: `simplify((0 + x))` will return `x`. Do the same for `0 * x` and `1 * x` (and also with `x * 1`, ...).
* derive expressions with respect to a given variable: e.g. `derive((5 + x), x)` would give `0+1`
  (and applying `simplify` will give `1`).
* make it possible for the user to save the current session as a file and to restore the session by loading the file.
  *Hint: the whole state of the session only depends on the user commands.*

