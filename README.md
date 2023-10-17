![](https://img.shields.io/badge/tests-passing-green&style=plastic)
![](https://img.shields.io/badge/Lua-2C2D72?logo=lua&logoColor=white&style=plastic)
![](https://img.shields.io/badge/purpose-xai,_optimization-blue)
![](https://img.shields.io/badge/platform-mac,_linux-orange)
[![](https://img.shields.io/badge/license-BSD2-yellow)](LICENSE.md)


<img align=right src="etc/img/lorax.png">

# LORAX

**LORAX** = LORAX Optimizes and Renders AI eXplanations**

Explore `N` options after evaluating `log(log(N))` examples.

1. Find two distant points. 
2. Score them _best, rest_.  
3. Prune everything closest to _rest_.
4. If more than `sqrt(N)` still exists
   - then go to step1.
   - else, report  the ranges that most distinguish the pruned from the _best_ rows.
