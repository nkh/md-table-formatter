# md-table-formatter

Formats markdown tables read from stdin or FILE and outputs to stdout.

## Usage

```text
    md-table-formatter.pl [OPTIONS] [FILE]
```

## Options

```text
  -s, --style N    Select table style (1-6, default: 1)
                   1 = Asciio style
                   2 = ASCII style (+, -, |)
                   3 = Light box-drawing (Unicode)
                   4 = Heavy box-drawing (Unicode)
                   5 = Markdown style (|)
                   6 = Minimal style (spaces only)
  -a, --align-all  Align columns across all tables in the document
  -h, --help       Show this help message
  --no-top         no top line
  --no-bottom      no bottom line
  --no-sides       no side lines
```

## Arguments

```text
  FILE             Input file (reads from stdin if not specified)
```

## CLI Examples

```bash
  cat table.md | md-table-formatter.pl -s 2

  md-table-formatter.pl -s 1 --align-all table.md
```

## Examples

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

Default output:

```text
.----------------------------------------.
| Operation                    | Bg      |
|------------------------------+---------|
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
