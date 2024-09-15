// Welcome to Browser Jam #001! 🚀
// Since this is the first-ever Browser Jam, your challenge will be to build a browser from scratch
// that can render the first-ever website: http://info.cern.ch/hypertext/WWW/TheProject.html

// The source is saved in the file `challenge.html` in this repository.

// Code to write:
// - HTML tokenizer and parser (construct tree)
// - Create window/OpenGL context
// - Render the tree
// - ???
// - Profit

import BrowserLib
import Foundation

let defaults = UserDefaults.standard
let path = defaults.string(forKey: "path") ?? "challenge.html"
let html = try BrowserLib.FileLoader.load(path: path)
//print(html)

var tokenizer = BrowserLib.HTMLTokenizer(input: html)
let tokens = try tokenizer.tokenize()
//print("Tokens: \(tokens)")

var parser = BrowserLib.HTMLParser(tokens: tokens)
let tree = try parser.parse()
print("Tree: \(tree)")

let app = try BrowserLib.Application()
try app.start()
