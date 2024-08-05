//
//  CountdownView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI

struct CountdownView: View {
    @StateObject var viewModel: CountdownViewModel
    
    @State private var pulsate = false
    
    var body: some View {
        Text(viewModel.timeRemaining)
            .font(.headline)
            .padding(.horizontal, 2)
            .foregroundColor(viewModel.isBelowTwoMinute ? .red : .primary)
            .scaleEffect(pulsate ? 1.2 : 1.0)
            .animation(viewModel.isBelowTwoMinute ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true) : .default, value: pulsate)
            .onAppear {
                if viewModel.isBelowTwoMinute {
                    pulsate = true
                }
            }
            .onReceive(viewModel.$isBelowTwoMinute) { isBelowOneMinute in
                if isBelowOneMinute {
                    withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                        pulsate = true
                    }
                } else {
                    pulsate = false
                }
            }
    }
}

