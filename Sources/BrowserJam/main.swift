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
import Raylib

let LIGHTGRAY = Color(r: 200, g: 200, b: 200, a: 255)
let RAYWHITE = Color(r: 245, g: 245, b: 245, a: 255)

let defaults = UserDefaults.standard
let path = defaults.string(forKey: "path") ?? "challenge.html"
let html = try String(contentsOfFile: "challenge.html", encoding: .utf8)
//print(html)

var tokenizer = BrowserLib.HTMLTokenizer(input: html)
let tokens = try tokenizer.tokenize()
//print("Tokens: \(tokens)")

var parser = BrowserLib.HTMLParser(tokens: tokens)
let tree = try parser.parse()
print("Tree: \(tree)")

// Check CI environment variable
if ProcessInfo.processInfo.environment["CI"] != nil {
    print("CI environment detected")
    exit(0)
}

// let app = try BrowserLib.Application()
// try app.start()

// Initialize raylib
InitWindow(800, 450, "raylib [core] example - basic window")

SetTargetFPS(60)  // Set our game to run at 60 frames-per-second

while !WindowShouldClose() {  // Detect window close button or ESC key
    BeginDrawing()
    ClearBackground(RAYWHITE)
    DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY)
    EndDrawing()
}

CloseWindow()  // Close window and OpenGL context
