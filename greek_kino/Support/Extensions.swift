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

extension Color {
//    static let mozzartYellowish = Color("MozzartYellow")
//    static let contentBackgroundCustom = Color("ContentBackground")
}
