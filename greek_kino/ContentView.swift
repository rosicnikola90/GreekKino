//
//  ContentView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI

struct ContentView: View {
    let gameManager = GameManager.shared
    @State var isLoadingWebView = false
    
    var body: some View {
        TabView {
            UpcomingGamesView()
                .tabItem {
                    Image(systemName: "arrowshape.up")
                    Text("Naredna")
                }
            LiveView()
                .tabItem {
                    Image(systemName: "play.circle")
                    Text("Uživo")
                }
            MyGamesView()
                .environmentObject(gameManager)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Moje Igre")
                }
            HistoryView()
                .environmentObject(gameManager)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Istorija")
                }
        }
    }
}

#Preview {
    ContentView()
}


