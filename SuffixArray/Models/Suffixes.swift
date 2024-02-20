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
    
    let taskQueue = TaskQueue(concurrency: 1)
    let storage: StorageService
    
    init(storage: StorageService) {
        self.storage = storage
    }
    
    private var content: [String: Int] = [:]
    
    @MainActor mutating func research(text: String) {
        content.removeAll()
        storage.clear()
        for element in text.components(separatedBy: " ") {
            let suffixes = SuffixSequence(element)
            self.append(suffixes)
        }
    }
    
    mutating private func append(_ sequence: SuffixSequence) {
        for suffix in sequence {
            add(suffix)
        }
    }
    
    mutating private func add(_ s: String) {
        content[s] = (content[s] ?? 0) + 1
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
    
    
    
    func getSorted(_ sort: Sort = .Asc, search: String? = nil) async -> [(String, Int)] {
        guard let search = search, !search.isEmpty else {
            return sort == .Asc ? content.sorted(by: < ) : content.sorted(by: >)
        }
        
        let result = try? await taskQueue.enqueue {
            content.filter({$0.key.lowercased().contains(search.lowercased())})
        }
        
        guard let filter = result?.result, let time = result?.time else {return []}
        
        await  storage.append(Searches(text: search, time: time))
        
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
