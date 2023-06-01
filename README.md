# Reveal

A simple tool for programatically revealing selected files in MacOS Finder.

Supports files passed as arguments or from standard input, either as absolute or relative paths.

## Installation

### Prerequisites

- macOS 10.15 (Catalina) or later
- Xcode and the Command Line Tools installed

### From source

Clone the repository and navigate to the project directory:

```sh
git clone https://github.com/inopinatus/reveal.git
cd reveal
```

Compile and install:

```sh
make install
```

Now you should be able to use `reveal` from anywhere in your terminal.  By default, the binary and manpage will be installed under `/usr/local`.  You can adjust locations using the variables in the Makefile, e.g. `make install PREFIX=/opt`.

## Usage

```
reveal [-0] [--] [files...]
  -0: Expect NUL (`\0`)-terminated filename strings on stdin
  --: End of options processing; all subsequent arguments are files
```

Either absolute and relative paths may be supplied, and may be mixed in the same invocation.  Relative paths will be resolved from the current working directory.

Paths may be passed as arguments, or from standard input, but not both.  If supplied via arguments whilst stdin has data available, then stdin will be ignored and the arguments will be used, and a warning will be issued.  This warning is suppressed by the `--` option.

Always supply the `--` option when passing filename(s) via arguments from within another script/application.  Not only does it silence the warning, this prevents misbehaviour when a relative path begins with a hyphen.

You may expect the Finder to open as many folder windows as sufficient and necessary to reveal all files specified.  Files that do not exist are silently ignored.

## Examples

1. Reveal files passed as arguments:

```sh
reveal file1.txt file2.txt
```

2. Find and reveal files with a PDF extension in your Documents folder and subfolders:

```sh
find ~/Documents -iname '*.pdf' -print0 | reveal -0
```

3. Reveal a file supplied from user input:

```sh
read -p 'file: ' FILENAME
reveal -- "$FILENAME"
```

## Backstory

The open(1) utility has a `-R` option but it performs badly in some cases. Notably, when multiple files share a folder, only one of them will be selected.

This utility was originally written for personal use as a zsh-AppleScript frankenscript that the excessively curious reader may find in `archive/reveal.zsh`.

## Contributing

Bug reports and pull requests are welcome on Github at https://github.com/inopinatus/reveal
