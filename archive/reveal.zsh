#!/bin/zsh

usage() {
    echo "usage: $(basename $0) [-0] [files...] [-h]"
    echo "  -0: Expect NUL ('\0') characters as separators on stdin"
    echo "  -h: Print this help message"
    exit 1
}

null_separated=false
file_arguments=false

while getopts ":0h" option; do
    case ${option} in
        0) null_separated=true ;;
        h) usage ;;
        *) echo "Invalid option: -$OPTARG" >&2; usage ;;
    esac
done
shift $((OPTIND-1))

if (( $# > 0 )); then
    file_arguments=true

    if $null_separated; then
        echo "Incompatible options: -0 and file arguments" >&2
        usage
    fi

    if read -t -k -u 0; then
        echo "Warning: Ignoring input on stdin since file arguments are present." >&2
    fi
fi

APPLESCRIPT='
  on run argv
    set fileAliases to {}
    set cwd to do shell script "pwd"

    repeat with filePath in argv
      if filePath starts with "/" then
        set posixPath to POSIX file filePath
      else
        set posixPath to POSIX file (cwd & "/" & filePath)
      end if

      set end of fileAliases to posixPath as alias
    end repeat

    tell application "Finder" to reveal fileAliases activate
  end run
'

if $file_arguments; then
    osascript -e "$APPLESCRIPT" -- "$@"
else
    if $null_separated; then
        xargs -0 osascript -e "$APPLESCRIPT" --
    else
        tr '\n' '\0' | xargs -0 osascript -e "$APPLESCRIPT" --
    fi
fi
