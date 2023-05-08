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

Now, you should be able to use `reveal` from anywhere in your terminal. By default, files will be installed under `/usr/local`. You can adjust locations using the variables in the Makefile, e.g. `make install PREFIX=/opt`.

## Usage

```
reveal [-0] [--] [files...]
  -0: Expect NUL (`\0`) characters as separators on stdin
  --: End of options processing; all subsequent arguments are files
```

File paths may be passed as arguments, or from standard input, but not both.  Either absolute and relative paths may be given.  Relative paths will be resolved from the current working directory.

Note that Finder will open as many folder windows as necessary to reveal all the files specified.  Files that do not exist will be silently ignored.

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
read -p 'file: ' FILENAME
reveal -- "$FILENAME"
```

## Motivation

The open(1) utility has a `-R` option but it performs badly in some cases. Notably, when multiple files share a folder, only one of them will be selected.

## Contributing

Bug reports and pull requests are welcome on Github at https://github.com/inopinatus/reveal
