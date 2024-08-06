//
//  CreateGameViewModel.swift
//  greek_kino
//
//  Created by Nikola Rosic on 5.8.24..
//

import SwiftUI

struct CreateGameView: View {
    
    @StateObject var viewModel: CreateGameViewModel
    @Binding var isPresented: UpcomingGameModel?
    let columns = Array(repeating: GridItem(.flexible()), count: 10)
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            Color(.contentBackground)
                .ignoresSafeArea()
            VStack(spacing: 8) {
                HStack {
                    Button(action: {
                        viewModel.showAlert = true
                    }) {
                        Image(systemName: "checkmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(viewModel.selectedNumbers.isEmpty ? .gray : .green)
                            .padding()
                    }
                    .disabled(viewModel.selectedNumbers.isEmpty)
                    Spacer()
                    CountdownView(viewModel: viewModel.countdownViewModel)
                    Spacer()
                    Button(action: {
                        isPresented = nil
                    }) {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .padding()
                    }
                }
                VStack {
                    Text("Broj Kola: \(FormatHelper.formatNumber(viewModel.game.visualDraw))")
                        .font(.headline)
                        .padding()
                    Text("Vreme Izvlačenja: \(FormatHelper.formatUnixTimeHHmm(viewModel.game.drawTime))")
                        .font(.headline)
                        .padding()
                    QuoteHorizontalView(viewModel: viewModel)
                        .padding(.vertical)
                    Spacer()
                    Text("Izaberi Kombinaciju")
                        .font(.headline)
                        .padding()
                    Divider()
                }
                .background(.mozzartYellow)
                
                HStack {
                    CustomButtonView(text: "Random") {
                        withAnimation {
                            viewModel.selectedNumbers = viewModel.generateUniqueRandomNumbers()
                        }
                    }
                    Spacer()
                    CustomButtonView(text: "Izbriši sve") {
                        viewModel.selectedNumbers.removeAll()
                    }
                }
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(1...80, id: \.self) { number in
                        CustomNumberView(number: number, backgroundColor: .clear, borderColor: viewModel.selectedNumbers.contains(number) ? Color.green : nil) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.numberPressed(number: number)
                            }
                            
                        }
                        .frame(height: 30)
                    }
                }
                .padding()
            }
        }

        .alert(isPresented: $viewModel.maxReached) {
            Alert(
                title: Text("Maximum reached!"),
                message: Text("You tried to selected more than 15 numbers"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $viewModel.countdownViewModel.reachedZero, content: {
            Alert(
                title: Text("Time Out!"),
                message: Text("Game started"),
                dismissButton: .default(Text("OK"), action: {
                    isPresented = nil
                })
            )
        })
        .alert("Kreiratti igru sa sledecim brojevima :\(viewModel.selectedNumbers)", isPresented: $viewModel.showAlert) {
            Button("Odustani", role: .cancel) {}
            Button("Kreiraj", action: addItem)
        } message: {
            Text("")
        }
    }
    
    private func addItem() {
        withAnimation {
            let quote = FormatHelper.getQuote(count: viewModel.selectedNumbers.count, starting: viewModel.startingQuote)
            let newGame = UserGameModel(game: viewModel.game, numbers: viewModel.selectedNumbers, quote: quote)
            modelContext.insert(newGame)
            isPresented = nil
        }
    }
}


struct QuoteHorizontalView: View {
    
    @ObservedObject var viewModel: CreateGameViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            HStack {
                VStack {
                    Text("Izabrano:")
                    Divider()
                    Text("Kvota:")
                }
                .frame(width: 80)
                Divider()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(1...15, id: \.self) { count in
                            VStack {
                                Text("\(count)")
                                    .font(.headline)
                                    .padding(.horizontal, 2)
                                    .foregroundColor(viewModel.selectedNumbers.count == count ? .red : .primary)
                                Divider()
                                Text("\(String(format: "%.2f", FormatHelper.getQuote(count: viewModel.selectedNumbers.count, starting: viewModel.startingQuote)))")
                                    .font(.headline)
                                    .padding(.horizontal, 2)
                                    .foregroundColor(viewModel.selectedNumbers.count == count ? .red : .primary)
                            }
                            .frame(width: 80)
                            .id(count)
                        }
                    }
                }
                .onChange(of: viewModel.selectedNumbers.count) { _, count in
                    withAnimation {
                        if count == 0 {
                            proxy.scrollTo(1, anchor: .leading)
                        } else {
                            proxy.scrollTo(count, anchor: .leading)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(height: 50)
    }
}









