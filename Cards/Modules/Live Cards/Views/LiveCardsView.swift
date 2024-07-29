import SwiftUI

struct LiveCardsView: View {
    @ObservedObject var viewModel = LiveCardsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.liveCardsViewState {
            case let .loaded(cards):
                LiveCardDataView(viewModel: viewModel, cards: cards)
            case .loading:
                EmptyCardView(viewModel: viewModel, text: "Loading...")
            case .error:
                EmptyCardView(viewModel: viewModel, text: "Sorry, Tap card to refresh")
            }
        }
        .onAppear {
            Task {
                viewModel.fetchCards()
            }
        }
    }
}

struct LiveCardDataView: View {
    @ObservedObject var viewModel = LiveCardsViewModel()
    @State private var path = NavigationPath()
    
    let cards: [Dictionary<String, [Card]>.Element]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(cards, id: \.key) { key, value in
                        Text(key)
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .center)
                        ForEach(value, id: \.id) { card in
                            NavigationLink(value: card) {
                                CardView(liveCardViewModel: viewModel, isFromSavedCardView: false, card: card)
                            }
                        }
                    }
                }
                .navigationDestination(for: Card.self) { card in
                    CardDetailsView(card: card)
                }
                .navigationTitle("Cards")
            }
        }
    }
}


#Preview {
    LiveCardsView()
}
