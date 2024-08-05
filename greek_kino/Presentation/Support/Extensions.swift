//
//  Extensions.swift
//  greek_kino
//
//  Created by Nikola Rosic on 5.8.24..
//

import Foundation
import SwiftUI

extension UITabBarAppearance {
    static func customAppearance() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        
        appearance.backgroundColor = UIColor(Color.contentBackground)
        
        let itemAppearance = UITabBarItemAppearance()
        
        itemAppearance.selected.iconColor = UIColor(Color.orange)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.mozzartYellow)]
        
        itemAppearance.normal.iconColor = UIColor(Color.primary)
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.secondary)]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        return appearance
    }
}

struct FormatHelper {
    
    static func formatUnixTimeHHmm(_ unixTime: Int, dateFormat: String = "HH:mm") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    static func formatNumber(_ number: Int) -> String {
           let numberFormatter = NumberFormatter()
           numberFormatter.usesGroupingSeparator = false
           numberFormatter.numberStyle = .decimal
           return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
       }
}
