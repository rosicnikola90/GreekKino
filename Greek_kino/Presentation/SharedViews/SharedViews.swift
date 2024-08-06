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
    func updateTimeRemaining(currentDate: Date = Date()) {
        let remaining = endTime.timeIntervalSince(currentDate)
        
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


struct UserGameCellView: View {
    let game: UserGameModel?
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    let historyGame: HistoryGameModel?
    let status: GameStatus
    let action: (()->())?
    
    init(game: UserGameModel, action: (()->())?) {
        self.game = game
        self.historyGame = nil
        self.status = FormatHelper.checkUnixTimeStatus((game.game.drawTime))
        self.action = action
    }
    
    init(historyGame: HistoryGameModel) {
        self.game = nil
        self.historyGame = historyGame
        self.status = FormatHelper.checkUnixTimeStatus((historyGame.drawTime ?? 0))
        self.action = nil
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Kolo: \(FormatHelper.formatNumber(game?.game.visualDraw ?? historyGame?.visualDraw ?? 0))")
                    Spacer()
                    Text("Vreme: \(FormatHelper.formatUnixTime((((game?.game.drawTime ?? historyGame?.drawTime) ?? 0))))")
                }
                HStack {
                    Text("Status: \(FormatHelper.checkUnixTimeStatus((game?.game.drawTime ?? historyGame?.drawTime) ?? 0).title)")
                    Spacer()
                    if game != nil {
                        Text("Kvota: \(String(format: "%.2f", game?.quote ?? 0))")
                    }
                }
               
                Text(game == nil ? "Izvuceni Brojevi:" : "Izabrani brojevi:")
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(game?.numbers ?? historyGame?.winningNumbers?.list ?? [], id: \.self) { item in
                        CustomNumberView(number: item, backgroundColor: .blue)
                            .frame(width: 40, height: 40)
                            .disabled(true)
                    }
                }
            }
            
            if game != nil, status == .finished {
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .frame(width: 10)
            }
        }
        .padding(4)
        .padding(.horizontal, 10)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(8)
        .onTapGesture {
            if status == .finished, game != nil {
                action?()
            }
        }
    }
}


struct AlertModifier: ViewModifier {
    @Binding var alertMessage: String?
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: .constant(alertMessage != nil)) {
                Alert(
                    title: Text("Error!"),
                    message: Text(alertMessage ?? ""),
                    dismissButton: .default(Text("OK")) {
                        alertMessage = nil
                    }
                )
            }
    }
}

extension View {
    func errorAlert(alertMessage: Binding<String?>) -> some View {
        self.modifier(AlertModifier(alertMessage: alertMessage))
    }
}
