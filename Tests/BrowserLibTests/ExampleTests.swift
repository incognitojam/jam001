import Testing

@Suite struct ExampleTests {
    @Test("Example test") func maths() {
        let a = 1
        let b = 2
        #expect(a + b == 3)
    }
}
