# Reveal

A simple tool for programatically revealing files, selected, in MacOS Finder.

Supports files passed as arguments or from standard input, either as absolute or relative paths.

## Installation

Either use as-is, or compile with `swiftc reveal.swift` to use as a binary.

## Requirements

- macOS with Swift 5.x

## Usage

```
reveal [-0] [--] [files...]
  -0: Expect NUL (`\0`) characters as separators on stdin
  --: End of options processing; all subsequent arguments are files
```

## Examples

1. Reveal files passed as arguments:

```sh
reveal file1.txt file2.txt
```

2. Find and reveal potentially many files scattered about:

```sh
find ~/Documents/*.txt -print0 | reveal -0
```

3. Reveal a file supplied from user input:

```sh
read FILENAME
reveal -- "$FILENAME"
```

## Motivation

The open(1) utility has a `-R` option but it performs badly in some cases. Notably, when multiple files share a folder, only one of them will be selected.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/inopinatus/reveal
