//
//  ContentView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        TabView {
            FutureGamesView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
            
            Text("dasdas222")
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
            
            Text("dasdas333")
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("Third")
                }
        }
    }
}

#Preview {
    ContentView()
}


