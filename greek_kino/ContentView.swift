//
//  ContentView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI

struct ContentView: View {
    @StateObject var gameManager = GameManager.shared
    @State var isLoadingWebView = false
    
    var body: some View {
        TabView {
            UpcomingGamesView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("Upcoming")
                }
            LiveView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Live")
                }
            MyGamesView()
                .environmentObject(gameManager)
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("My Games")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "4.square.fill")
                    Text("History")
                }
        }
    }
}

#Preview {
    ContentView()
}


