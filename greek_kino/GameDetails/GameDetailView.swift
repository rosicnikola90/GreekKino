import SwiftUI

struct GameDetailView: View {

    @StateObject var viewModel: GameDetailsViewModel
    @Binding var isPresented: UpcomingGameModel?
    let columns = Array(repeating: GridItem(.flexible()), count: 10)
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    addItem()
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
            Text("Game No.: \(viewModel.game.drawId)")
                .font(.headline)
            QuoteHorizontalView(viewModel: viewModel)
                .padding(.vertical, 12)
            Spacer()
            HStack {
                CustomButtonView(text: "Random") {
                    
                }
                Spacer()
                CustomButtonView(text: "Clear all") {
                    viewModel.selectedNumbers.removeAll()
                }
            }
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(1...80, id: \.self) { number in
                    CustomNumberView(number: number, backgroundColor: Color("ContentBackground"), borderColor: viewModel.selectedNumbers.contains(number) ? Color.green : nil) {
                        withAnimation(.easeInOut) {
                            viewModel.numberPressed(number: number)
                        }
                    }
                    //                    Button(action: {
                    //                        withAnimation(.easeInOut) {
                    //                            viewModel.numberPressed(number: number)
                    //                        }
                    //                    }) {
                    //                        Text("\(number)")
                    //                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //                            .aspectRatio(1, contentMode: .fit)
                    //                            .background(viewModel.selectedNumbers.contains(number) ? Color.green : Color.blue)
                    //                            .foregroundColor(.white)
                    //                            .cornerRadius(2)
                    //                    }
                }
            }
            .padding()
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
    }
    
    private func addItem() {
        withAnimation {
            let newGame = UserGameModel(game: viewModel.game, numbers: viewModel.selectedNumbers)
            modelContext.insert(newGame)
        }
    }
}


struct QuoteHorizontalView: View {
    
    @ObservedObject var viewModel: GameDetailsViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            HStack {
                VStack {
                    Text("Count:")
                    Divider()
                    Text("Quote:")
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
                                Text("\(String(format: "%.2f", Double(count) * viewModel.startingQuote * pow(1.5, Double(count))))")
                                    .font(.headline)
                                    .padding(.horizontal, 2)
                                    .foregroundColor(viewModel.selectedNumbers.count == count ? .red : .primary)
                            }
                            .frame(width: 80)
                            .id(count)
                        }
                    }
                }
                .onChange(of: viewModel.selectedNumbers.count) { count in
                    withAnimation {
                        proxy.scrollTo(count, anchor: .leading)
                    }
                }
            }
        }
        .padding()
        .frame(height: 50)
    }
}

struct CustomButtonView: View {
    let text: String
    let backgroundColor = Color("MozzartYellow")
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


final class GameDetailsViewModel: ObservableObject {
    
    let game: UpcomingGameModel
    @Published var selectedNumbers: [Int] = []
    var countdownViewModel: CountdownViewModel
    @Published var maxReached = false
    let startingQuote = 3.75
    
    init(game: UpcomingGameModel) {
        self.game = game
        self.countdownViewModel = CountdownViewModel(drawTime: game.drawTime)
    }
    
    func numberPressed(number: Int) {
        if let index = selectedNumbers.firstIndex(of: number) {
            selectedNumbers.remove(at: index)
        } else {
            if selectedNumbers.count == 15 {
                maxReached = true
            } else {
                selectedNumbers.append(number)
            }
        }
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
