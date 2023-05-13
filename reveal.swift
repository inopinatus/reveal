#!/usr/bin/swift

import AppKit

func usage() {
    let progname = URL(fileURLWithPath: CommandLine.arguments[0]).lastPathComponent
    fputs("usage: \(progname) [-0] [--] [files...]\n", stderr)
    fputs("  -0: Expect NUL ('\\0') characters as separators on stdin\n", stderr)
    fputs("  --: End of options processing; all subsequent arguments are files\n", stderr)
    exit(1)
}

func isInputAvailable() -> Bool {
    var pollFD = pollfd(fd: STDIN_FILENO, events: Int16(POLLIN), revents: 0)
    return poll(&pollFD, 1, 0) > 0 && (pollFD.revents & Int16(POLLIN)) != 0
}

var nullSeparated = false
var fileArguments = false

// Start of options processing
var args = CommandLine.arguments.dropFirst()
loop: while let arg = args.first, arg.starts(with: "-") {
    args = args.dropFirst()

    switch arg {
    case "-0":
        nullSeparated = true
    case "--":
        fileArguments = true
        break loop
    default:
        fputs("Invalid option: \(arg)\n", stderr)
        usage()
    }
}

if !(fileArguments || args.isEmpty) {
    fileArguments = true

    if isInputAvailable() {
        fputs("Ignoring input on stdin due to file arguments\n", stderr)
    }
}

if fileArguments && nullSeparated {
    fputs("Ignoring -0 option due to file arguments\n", stderr)
}
// End of options processing

let files = fileArguments ? AnySequence(args)
          : nullSeparated ? AnySequence(FileHandle.standardInput.availableData.split(separator: 0).lazy.compactMap { String(data: Data($0), encoding: .utf8) })
          : AnySequence { AnyIterator { readLine() } }

let urls = files.compactMap { URL(fileURLWithPath: $0).absoluteURL }

if urls.isEmpty {
    exit(0)
}

NSWorkspace.shared.activateFileViewerSelecting(urls)
