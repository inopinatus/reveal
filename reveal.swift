#!/usr/bin/swift

import AppKit
import Darwin
import Foundation

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

struct InputIterator: IteratorProtocol {
    let separator: UInt8
    init(separator: UInt8) { self.separator = separator }

    func next() -> String? {
        var buffer = Data()
        while true {
            var char: UInt8 = 0
            if read(STDIN_FILENO, &char, 1) < 1 {
                return nil
            } else if char == separator {
                defer { buffer.removeAll() }
                return String(data: buffer, encoding: .utf8)
            } else {
                buffer.append(char)
            }
        }
    }
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

let files = fileArguments
            ? AnySequence(args)
            : AnySequence {
                InputIterator(separator: nullSeparated ? 0 : UInt8(ascii: "\n"))
            }

let urls = files.compactMap { URL(fileURLWithPath: $0).absoluteURL }

if urls.isEmpty {
    exit(0)
}

NSWorkspace.shared.activateFileViewerSelecting(urls)
