import BrowserLib
import Testing

@Suite struct HTMLTokenizerTests {
    @Test("Tokenize HTML") func tokenizeHTML() {
        let html = """
            <HEADER>
            <TITLE>The World Wide Web project</TITLE>
            <NEXTID N="55">
            </HEADER>
            <BODY>
            <H1>World Wide Web</H1>The WorldWideWeb (W3) is a wide-area<A
            NAME=0 HREF="WhatIs.html">
            hypermedia</A> information retrieval
            initiative aiming to give universal
            access to a large universe of documents.
            """

        var tokenizer = BrowserLib.HTMLTokenizer(input: html)
        let tokens = try! tokenizer.tokenize()
        #expect(tokens.count == 15)
    }
}
