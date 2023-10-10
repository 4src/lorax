# How to Contribute to this Code

Please following the following code conventions.

## Modules

- Divide code into chunks small enough to include into less than
  one column of a two column latex file
- Store all chunks inside its own module; e.g. see `str` in [lib.lua](lib.lua).

## Globals

- Try to avoid them.
- `the` is the global storing control settings, set from a help string shown top of file.

## Command-line

- If `the` has a flag `XXX` then the cli needs to update `XXX` from
   the  `-X` and `--XXX` flags.
- If `XXX` is a boolean, the command-line flag needs no argument (we just
  flip the current value). For more on this, see `str.cli` in [lib.lua](lib.lua)

## Functions

- Use the `local` keyword as little as possible (clutters code);

## Classes

- no inheritance (harder to debug)
- class names in UPPER CASE

## Type hints

- If XX is a class name, then `xx`,  `xx1`  refers to an instance.
- In function body, name your variables anything you like.
- In function header:
  - `z` denotes anything at all; e.g. `z`
  - `s` denotes a string; e.g. `s,s1`
  - `t,u` denotes  lists (or "table" in Lua speak); e.g. `t,t1,u,t1`
  - `n` denotes a number; e.g. `n1`
  - `p` denotes a boolean; e.g. `usep`
  - `xs` denotes a list of `x`; e.g. `ss` is a list of strings
  - two spaces denotes start of optional parameters
  - four spaces denotes start of local parameters.

## Documentation

- All .lua files max line = 65 characters (so we we lay out code in two-column
  latex files)
- Minimal doc in X.lua files; instead use X.md and the `_snips` tool to add
  in code samples between Markdown
- If a line is only `end` then consider appending it to line above.
- Try to write a test suite that demos the code.

## Tests

- Stored in a local `eg` in a file called `egs.lua`.
- Named (e.g.) `eg.tag_help_text()` where `tag` is how we can call it from the
  command line and `help_text` is what is displayed in help text (with the `_`
  replaced by a space),
- Tests will run in any order.
- Tests that return `false` will add 1 to a `fails` counter.
- When tests terminate, they return `fails` to the operating system.

## Make tools and short cuts

- Use the `_` file.
- Document usually functions with a help string after `##; e.g. see below.
- Add a short cut to useful function; e.g see below

```sh
_g()  { _gp; } 
_gp() {  ## _g          ;  commit all, push to github 
   git commit -am saving; git push; git status; }
```

- Add some install script to check for required code; e.g.

```sh
for x in gawk lua5.3; do 
  command -v $x > /dev/null || sudo apt install $x; done
```