# Imagine the Instruction#wtf creates a string result from #derive,
# and also avoids interpreting its arguments.
#
# Instead, it produces string results with explanatory power:

block {
  block {
    value «int»
    value «int»
    do int_multiply
    do int_negative
    ref x1
    ref x2
    do int_min
    ref x1}
  do int_subtract
  block {
    ref x1}
  do int_shove
  do int_add
  value «int»
  block {
    value «int»
    ref x2
    value «int»
    do int_modulo}}
«int» 12
«int» -91
«int» 671
«int» -291056
«int» 8

# assuming x1 <- 8, x2 <- 31

:int: -
:int: -
:int: "12"
:int: "-91"
:int: "(12 * -91)"
:int: "-(12 * -91)"
:int: "-(12 * -91)", "x1"
:int: "-(12 * -91)", "x1", "x2"
:int: "-(12 * -91)", "min(x1, x2)"
:int: "-(12 * -91)", "min(x1, x2)", "x1"
:int: "-(12 * -91)", "(min(x1, x2) - x1)"
:int: "-(12 * -91)"  # shove? seems as if we need to look up actual numbers as well
:int: "-(12 * -91)"
:int: "-(12 * -91)", "671"
:int: "-(12 * -91)", "671", "-291056"
:int: "-(12 * -91)", "671", "-291056", "x2"
:int: "-(12 * -91)", "671", "-291056", "x2", "8"
:int: "-(12 * -91)", "671", "-291056", "(x2 % 8)"











:int: "(12 * -91)"
:int: "(12 * -91)"




