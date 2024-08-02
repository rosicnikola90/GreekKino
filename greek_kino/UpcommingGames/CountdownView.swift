//
//  CountdownView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI

struct CountdownView: View {
    @ObservedObject var viewModel: CountdownViewModel
    
    @State private var pulsate = false
    
    var body: some View {
        Text(viewModel.timeRemaining)
            .font(.headline)
            .padding(.horizontal, 2)
            .foregroundColor(viewModel.isBelowOneMinute ? .red : .primary)
            .scaleEffect(pulsate ? 1.2 : 1.0)
            .animation(viewModel.isBelowOneMinute ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true) : .default, value: pulsate)
            .onAppear {
                if viewModel.isBelowOneMinute {
                    pulsate = true
                }
            }
            .onReceive(viewModel.$isBelowOneMinute) { isBelowOneMinute in
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

#Preview {
    CountdownView(viewModel: CountdownViewModel(drawTime: 131452354235))
}
