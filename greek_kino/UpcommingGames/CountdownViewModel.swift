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
    @Published var isBelowOneMinute: Bool = false
    @Published var reachedZero: Bool = false
    private var timer: AnyCancellable?
    private var endTime: Date
    
    init(drawTime: Int) {
        self.endTime = Date(timeIntervalSince1970: TimeInterval(drawTime) / 1000)
        self.startTimer()
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.updateTimeRemaining()
            }
    }
    
    private func updateTimeRemaining() {
        let now = Date()
        let remaining = endTime.timeIntervalSince(now)
        
        if remaining <= 0 {
            timer?.cancel()
            timeRemaining = "00:00"
            isBelowOneMinute = false
            reachedZero = true
        } else {
            let minutes = Int(remaining) / 60
            let seconds = Int(remaining) % 60
            timeRemaining = String(format: "%02d:%02d", minutes, seconds)
            isBelowOneMinute = remaining < 60
        }
    }
    
    deinit {
        timer?.cancel()
    }
}
