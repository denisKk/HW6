//
//  StorageService.swift
//  SuffixArray
//
//  Created by Dev on 25.01.24.
//

import Foundation
import UIKit
import SwiftUI

final class StorageService: ObservableObject {
    @Published var arrayData: [Searches] = .init()
    
    @MainActor
    func append(_ data: Searches) {
        arrayData.append(data)
    }
    
    @MainActor
    func clear() {
        arrayData.removeAll()
    }
    
    var maxTime: Double {
        arrayData.map({$0.time}).max() ?? 0
    }
    
    var minTime: Double {
        arrayData.map({$0.time}).min() ?? 0
    }
 
    
    func getColor(value: Double) -> Color {
        let startColor: UIColor = .green
        let endColor: UIColor = .red
        let factor: CGFloat = CGFloat((value - minTime)/(maxTime - minTime))
        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0

        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)

        let interpolatedRed = startRed + factor * (endRed - startRed)
        let interpolatedGreen = startGreen + factor * (endGreen - startGreen)
        let interpolatedBlue = startBlue + factor * (endBlue - startBlue)

        return Color(red: interpolatedRed, green: interpolatedGreen, blue: interpolatedBlue)
    }
}
