
import SwiftUI

@main
struct SuffixArrayApp: App {
    
    let storage: StorageService = .init()
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(storage)
        }
    }
}
