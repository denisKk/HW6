import Foundation

struct Suffixes {
    
    enum Sort {
        case Asc, Desc
        
        mutating func toogle() {
                switch self {
                case .Asc:
                    self = .Desc
                case .Desc:
                    self = .Asc
                }
            }
    }
    
    init() {}
    
    init(text: String) {
        self.init()
        for element in text.components(separatedBy: " ") {
            let suffixes = SuffixSequence(element)
            self.append(suffixes)
        }
    }
    
    private var content: [String: Int] = [:]
    
    mutating private func append(_ sequence: SuffixSequence) {
        for suffix in sequence {
            add(suffix)
        }
    }
    
    mutating private func add(_ s: String) {
        if let count = content[s] {
            content[s] = count + 1
        } else {
            content[s] = 1
        }
    }
    
    var max: Int {
        content.values.max() ?? 0
    }
    
    var uniqueCount: Int {
        content.count
    }
    
    var allCount: Int {
        content.reduce(0, { res, dict in res + dict.value})
    }

    func getSorted(_ sort: Sort = .Asc, search: String? = nil) -> [(String, Int)] {
        guard let search = search, !search.isEmpty else {
            return sort == .Asc ? content.sorted(by: < ) : content.sorted(by: >)
        }
        let filter = content.filter({$0.key.lowercased().contains(search.lowercased())})
        return sort == .Asc ? filter.sorted(by: < ) : filter.sorted(by: >)
    }
    
    func getTop10Triple() -> [(String, Int)] {
        let sorted = content.filter({$0.key.count == 3}).sorted(by: {$0.value < $1.value})
        return sorted.suffix(10).reversed()
    }
}

extension Suffixes: Sequence {
    func makeIterator() -> DictionaryIterator <String, Int> {
        content.makeIterator()
    }
}
