//
//  HistoryView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 4.8.24..
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel = HistoryViewModel()
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        ZStack {
            if gameManager.loading {
                LoadingView()
            } else {
                Color(.contentBackground)
                    .ignoresSafeArea()
                VStack {
                    HStack(alignment: .top) {
                        Spacer()
                        Spacer()
                        Text("Istorija Kola")
                            .font(.headline)
                            .padding()
                        Spacer()
                        Button(action: {
                            if viewModel.searchedGame == nil {
                                viewModel.showingSearchAlert = true
                            } else {
                                withAnimation {
                                    viewModel.searchedGame = nil
                                }
                                viewModel.searchedGameOnChange = nil
                            }
                        }) {
                            Image(systemName: viewModel.searchedGame != nil ? "xmark.circle" : "magnifyingglass.circle")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .padding()
                        }
                        
                    }
                    
                    if let game = viewModel.searchedGame {
                        UserGameCellView(historyGame: game)
                            .padding(8)
                        Spacer()
                    } else {
                        HStack {
                            CustomButtonView(text: "Od datuma: \(FormatHelper.formatDateToddMMyyyy(viewModel.fromDate))") {
                                viewModel.showFromDatePicker = true
                            }
                            Spacer()
                            CustomButtonView(text: "Do datuma: \(FormatHelper.formatDateToddMMyyyy(viewModel.toDate))") {
                                viewModel.showToDatePicker = true
                            }
                        }
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.historyGames) { game in
                                    UserGameCellView(historyGame: game)
                                        .padding(8)
                                }
                            }
                            .background(Color(.systemBackground))
                        }
                        .refreshable {
                            viewModel.getHistoryGames()
                        }
                    }
                }
            }
            
            if viewModel.showFromDatePicker || viewModel.showToDatePicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                CustomDatePickerView(
                    selectedDate: viewModel.showFromDatePicker ? $viewModel.fromDate : $viewModel.toDate,
                    showPicker: viewModel.showFromDatePicker ? $viewModel.showFromDatePicker : $viewModel.showToDatePicker
                )
            }
        }
        .onAppear(perform: {
            if viewModel.historyGames.isEmpty {
                viewModel.getHistoryGames()
            }
        })
        .onChange(of: viewModel.historyGamesOnChange) { _, newValue in
            withAnimation(.easeInOut) {
                viewModel.historyGames = newValue
            }
        }
        .onChange(of: viewModel.searchedGameOnChange) { _, newValue in
            withAnimation(.easeInOut) {
                viewModel.searchedGame = newValue
            }
        }
        .alert("Unesite broj Kola:", isPresented: $viewModel.showingSearchAlert) {
            TextField("broj..", text: $viewModel.searchText)
                .keyboardType(.numberPad)
            Button("Zatvori", role: .cancel) {}
            Button("Pretrazi", action: viewModel.search)
        } message: {
            Text("")
        }
        .errorAlert(alertMessage: $viewModel.alertMessage)
    }
    
}



#Preview {
    HistoryView()
        .environmentObject(GameManager.shared)
}



struct CustomDatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var showPicker: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showPicker = false
                }
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .foregroundColor(Color(.black))
                
                CustomButtonView(text: "Izaberi") {
                    showPicker = false
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding()
        }
    }
}

