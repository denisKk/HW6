
struct SuffixSequence: Sequence {
    
    private let text: String
    
    init(_ text: String){
        self.text = text
    }
    
    func makeIterator() -> SuffixIterator {
        SuffixIterator(text: text)
    }
}


struct SuffixIterator: IteratorProtocol {
    let text: String
    var state: Int = 0

    mutating func next() -> String? {
        state += 1
        return state <= text.count ? String(text.suffix(state)) : nil
    }
}
