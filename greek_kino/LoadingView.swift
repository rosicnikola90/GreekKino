//
//  LoadingView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2) // Increase the size of the spinner
                .padding()
            Text("Loading...")
                .font(.headline)
                .padding()
            Spacer()
        }
        .background(Color(.systemBackground).opacity(0.8))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    LoadingView()
}
