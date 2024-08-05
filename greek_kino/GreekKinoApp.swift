//
//  GreekKinoApp.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI
import SwiftData

@main
struct GreekKinoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserGameModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        let appearance = UITabBarAppearance.customAppearance()
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .preferredColorScheme(.dark)

        }
        .modelContainer(sharedModelContainer)
    }
            
}

