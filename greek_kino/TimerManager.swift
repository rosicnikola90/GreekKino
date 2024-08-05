//
//  TimerManager.swift
//  greek_kino
//
//  Created by Nikola Rosic on 5.8.24..
//

import Foundation
import Combine


final class TimerManager: ObservableObject {
    static let shared = TimerManager()
    
    @Published var currentDate = Date()
    private var timer: AnyCancellable?
    
    private init() {
        startTimer()
    }
    
    private func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { [weak self] currentTime in
                self?.currentDate = currentTime
            }
    }
    
    deinit {
        timer?.cancel()
    }
}
