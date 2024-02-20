//
//  HistoryView.swift
//  SuffixArray
//
//  Created by Dev on 25.01.24.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var storage: StorageService
    
    var body: some View {
        ZStack {
            Color.darkGray
                .ignoresSafeArea()
            
            VStack {
                title
                table
            }
        }
    }
    
    @ViewBuilder
    var title: some View {
        Text("History Searches")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    var table: some View {
        ScrollView {
            VStack {
                ForEach(Array(storage.arrayData.enumerated()), id: \.offset) { index, element in
                    HStack {
                        Text("\(index + 1).")
                        Text(element.text)
                        Spacer()
                        Text(String(format: "%.9f", element.time))
                            .foregroundStyle(storage.getColor(value: element.time))
                            .bold()
                    }
                    .padding()
                    Divider()
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
