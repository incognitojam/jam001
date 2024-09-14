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

import Foundation

struct AppArguments {
    var path: String

    init() {
        let defaults = UserDefaults.standard
        self.path = defaults.string(forKey: "path") ?? "challenge.html"
    }
}

let args = AppArguments()
let html = try FileLoader.load(path: args.path)
//print(html)

var tokenizer = HTMLTokenizer(input: html)
let tokens = try tokenizer.tokenise()
print(tokens)
