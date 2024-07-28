import SwiftUI

struct LiveCardsView: View {
    @ObservedObject var viewModel = LiveCardViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.liveCardsViewState {
            case let .loaded(cards):
                LiveCardDataView(cards: cards)
                    .environmentObject(viewModel)
            case .loading:
                EmptyCardView(text: "Loading...")
            case .error:
                EmptyCardView(text: "Oops, Tap to refresh")
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
    @ObservedObject var viewModel = LiveCardViewModel()
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
                                CardView(isCardSaved: false, isFromSavedCardView: false, card: card)
                                    .environmentObject(viewModel)
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
