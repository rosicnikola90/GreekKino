//
//  CountdownViewModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI
import Combine

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
