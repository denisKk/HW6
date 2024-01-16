

enum ListMode: CaseIterable {
    case all, top10Triple
    
    var description: String {
        switch self {
        case .all:
            return  "All"
        case .top10Triple:
            return "Top-10"
        }
    }
}
