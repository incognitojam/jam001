import BrowserLib
import Testing

@Suite struct FileLoaderTests {
    @Test("Load file") func loadFile() {
        let path = "challenge.html"
        let html = try! BrowserLib.FileLoader.load(path: path)
        #expect(html.contains("<TITLE>The World Wide Web project</TITLE>"))
    }
}
