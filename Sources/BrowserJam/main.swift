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

let defaults = UserDefaults.standard
let path = defaults.string(forKey: "path") ?? "challenge.html"
let html = try String(contentsOfFile: "challenge.html", encoding: .utf8)
// print("HTML: \(html)")

var tokenizer = BrowserLib.HTMLTokenizer(input: html)
let tokens = try tokenizer.tokenize()
// print("Tokens: \(tokens)")

var parser = BrowserLib.HTMLParser(tokens: tokens)
let tree = try parser.parse()
print("Tree: \(tree)")

// Check CI environment variable
if ProcessInfo.processInfo.environment["CI"] != nil {
    print("CI environment detected")
    exit(0)
}

SetConfigFlags(UInt32(FLAG_WINDOW_RESIZABLE.rawValue))
InitWindow(800, 450, "Jam Browser")
SetTargetFPS(60)

let font = LoadFontEx("Resources/Fonts/times.ttf", 32, nil, 95)
let layoutEngine = BrowserLib.LayoutEngine(font)
let renderer = BrowserLib.Renderer()

let LIGHTGRAY = Color(r: 200, g: 200, b: 200, a: 255)
let RAYWHITE = Color(r: 245, g: 245, b: 245, a: 255)
let RED = Color(r: 255, g: 0, b: 0, a: 255)
let BLACK = Color(r: 0, g: 0, b: 0, a: 255)

var layoutContext = BrowserLib.LayoutContext(screenWidth: Float(GetRenderWidth()))
var layout = layoutEngine.layout(node: tree.root, in: layoutContext)

var renderCommands = renderer.render(layout: layout)

while !WindowShouldClose() {
    BeginDrawing()
    ClearBackground(RAYWHITE)

    if Float(GetRenderWidth()) != layoutContext.screenWidth {
        layoutContext = layoutContext.with(screenWidth: Float(GetRenderWidth()))
        layout = layoutEngine.layout(node: tree.root, in: layoutContext)
        renderCommands = renderer.render(layout: layout)
        print("Layout: \(layout)")
    }

    renderCommands.forEach { command in
        switch command {
        case .drawRect(let x, let y, let width, let height):
            DrawRectangleLines(Int32(x), Int32(y), Int32(width), Int32(height), RED)
        case .drawText(let x, let y, let text):
            DrawTextEx(font, text, Vector2(x: x, y: y), Float(font.baseSize), 1.0, BLACK)
        }
    }

    EndDrawing()
}

CloseWindow()
