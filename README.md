# md-table-formatter

Formats markdown tables read from stdin or FILE and outputs to stdout.

## Usage

```text
    md-table-formatter.pl [OPTIONS] [FILE]
```

## Options

```text
Options:
  --style|s N          table style
                       0 = Markdown (default)
                       1 = Asciio
                       2 = ASCII (+, -, |)
                       3 = Light box-drawing (Unicode)
                       4 = Heavy box-drawing (Unicode)
                       5 = Minimal (spaces only)
                       6 = horizontal lines only

  --align-all|a        align columns across all tables in the document
  --max-width|m N      maximum table width
  --max-row-width|r N  maximum row width, prepends '@' to rows that are too long 
  --check-width|c      also output an errors on stderr
  --no-top             no top line
  --no-bottom          no bottom line
  --no-sides           no side lines
  --from-TSV           convert from TSV format to markdown table
  --TSV-no-header      do not treat the first line as a header when converting from TSV
  --help|h             show this help message
```

## Arguments

```text
  FILE             Input file (reads from stdin if not specified)
```

## Input 

*md-table-formatter* only accepts markdown style tables as input.

## Output

Non-table lines are printed as is, tables are formatted. Both are written to stdout. 

If the --maxi-width is exceeded, the table will be printed as is.

If the --max-row-width option is specified, any rows that exceed the maximum row width will be have '@' prepended.

If --max-row-width and --check-width is set, error will also be reported to stderr and the exit code set to 1; this lets
you use md-table-formatter in a CI/CD pipeline to check for table formatting issues.

## Vim integration

```vim
nnoremap <Leader>at vip:!md-table-formatter --max-row-width 185<CR>
xnoremap <Leader>at :!md-table-formatter --max-row-width 185<CR>
```

## AI Skills integration

There is an example skill, and how to install it, in the `use_as_skill` directory.

## CLI Examples

```bash
  cat table.md | md-table-formatter.pl -s 2

  md-table-formatter.pl -s 1 --align-all table.md
```

## Styles

Input:

```text
| Operation              | Bg     | 
| -----------                  | -----   |
| Edit selected element | douck |
| Add to selection                    | C00-1 |
| Quick link                   | 0A0-1 |
| Duplicate elements           | 0AS-1 |
| Insert flex point (in arrow) | CA0-1 |
```

Style 0 with no top nor bottom:

```text
| Operation                    | Bg      |
|------------------------------|---------|
| Edit selected element        | «douck» |
| Add to selection             | «C00-1» |
| Quick link                   | «0A0-1» |
| Duplicate elements           | «0AS-1» |
| Insert flex point (in arrow) | «CA0-1» |
```

Default style (1):

```text
.----------------------------------------.
| Operation                    | Bg      |
|------------------------------|---------|
| Edit selected element        | «douck» |
| Add to selection             | «C00-1» |
| Quick link                   | «0A0-1» |
| Duplicate elements           | «0AS-1» |
| Insert flex point (in arrow) | «CA0-1» |
'----------------------------------------'
```

Style 4, no top nor bottom:

```text
 Operation                    ║ Bg
══════════════════════════════╬═════════
 Edit selected element        ║ «douck»
 Add to selection             ║ «C00-1»
 Quick link                   ║ «0A0-1»
 Duplicate elements           ║ «0AS-1»
 Insert flex point (in arrow) ║ «CA0-1»
```

## Multiple tables and extra text

Input:

```text
# text that is not in a table will be passed back as is

| Operation               | Bg      |
| -----------                  | -----   |
| Edit selected element | douck |
| Add to selection                    | C00-1 |
| Quick link                   | 0A0-1 |
| Duplicate elements           | 0AS-1 |
| Insert flex point (in arrow) | CA0-1 |

| Operation                    | Binding        |extra|
| -----------                  | ---------      ||
| Edit selected element | double-click  |
| Add to selection             | C00-button-1 |a
| Quick link                   | 0A0-button-1 ||
| Duplicate elements              | 0AS-button-1 ||
| Insert flex point (in arrow) | CA0-button-1 ||
```

Output:

```text

# text that is not in a table will be passed back as is

.--------------------------------------.
| Operation                    | Bg    |
|------------------------------+-------|
| Edit selected element        | douck |
| Add to selection             | C00-1 |
| Quick link                   | 0A0-1 |
| Duplicate elements           | 0AS-1 |
| Insert flex point (in arrow) | CA0-1 |
'--------------------------------------'

.-----------------------------------------------------.
| Operation                    | Binding      | extra |
|------------------------------+--------------+-------|
| Edit selected element        | double-click |       |
| Add to selection             | C00-button-1 | a     |
| Quick link                   | 0A0-button-1 |       |
| Duplicate elements           | 0AS-button-1 |       |
| Insert flex point (in arrow) | CA0-button-1 |       |
'-----------------------------------------------------'
```

## Aligned tables

```text
.-----------------------------------------------------.
| Operation                    | Bg           |       |
|------------------------------+--------------+-------|
| Edit selected element        | douck        |       |
| Add to selection             | C00-1        |       |
| Quick link                   | 0A0-1        |       |
| Duplicate elements           | 0AS-1        |       |
| Insert flex point (in arrow) | CA0-1        |       |
'-----------------------------------------------------'

.-----------------------------------------------------.
| Operation                    | Binding      | extra |
|------------------------------+--------------+-------|
| Edit selected element        | double-click |       |
| Add to selection             | C00-button-1 | a     |
| Quick link                   | 0A0-button-1 |       |
| Duplicate elements           | 0AS-button-1 |       |
| Insert flex point (in arrow) | CA0-button-1 |       |
'-----------------------------------------------------'
```
