//
//  MainScreen.swift
//  SuffixArray
//
//  Created by Dev on 25.01.24.
//

import SwiftUI

enum Tabs {
    case suffixes
    case history
}

struct MainScreen: View {
    @State var selectionTab: Tabs = .suffixes
    @EnvironmentObject var storage: StorageService
    
    var body: some View {
        TabView(selection: $selectionTab) {
            SuffixesView(storage: storage)
                .tabItem { Text("Suffixes") }
                .tag(Tabs.suffixes)
            
            HistoryView()
                .tabItem { Text("History") }
                .tag(Tabs.history)
        }
    }
}

#Preview {
    MainScreen()
}
