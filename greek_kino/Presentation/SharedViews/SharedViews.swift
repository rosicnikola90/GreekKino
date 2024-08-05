//
//  SharedViews.swift
//  greek_kino
//
//  Created by Nikola Rosic on 5.8.24..
//

import SwiftUI
import Combine

struct CustomButtonView: View {
    let text: String
    let backgroundColor = Color(.mozzartYellow)
    let cornerRadius = 8.0
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(Color.primary)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
        .padding([.leading, .trailing], 8)
    }
}

struct CustomNumberView: View {
    var number: Int
    var backgroundColor: Color
    var borderColor: Color?
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: action ?? {}) {
            Text("\(number)")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor ?? .clear, lineWidth:  borderColor != nil ? 3 : 0)
                )
        }
    }
}

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



final class CountdownViewModel: ObservableObject {
    @Published var timeRemaining: String = ""
    @Published var isBelowTwoMinute: Bool = false
    @Published var reachedZero: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var endTime: Date
    
    init(drawTime: Int) {
        self.endTime = Date(timeIntervalSince1970: TimeInterval(drawTime) / 1000)
        observeTimer()
        updateTimeRemaining()
    }
    
    private func observeTimer() {
        TimerManager.shared.$currentDate
            .sink { [weak self] _ in
                self?.updateTimeRemaining()
            }
            .store(in: &cancellables)
    }
    
    private func updateTimeRemaining() {
        let now = Date()
        let remaining = endTime.timeIntervalSince(now)
        
        if remaining <= 0 {
            timeRemaining = "00:00"
            isBelowTwoMinute = false
            reachedZero = true
        } else {
            let minutes = Int(remaining) / 60
            let seconds = Int(remaining) % 60
            timeRemaining = String(format: "%02d:%02d", minutes, seconds)
            isBelowTwoMinute = remaining < 120
            reachedZero = false
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

