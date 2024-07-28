import SwiftUI

struct SavedCardsView: View {
    @ObservedObject var viewModel = SavedCardsViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.savedCardsViewState {
            case let .loaded(cards):
                SavedCardsDataView(cards: cards)
                    .environmentObject(viewModel)
            case .loading:
                EmptyCardView(text: "Loading....")
            case .error:
                EmptyCardView(text: "Please save a card to view")
            }
        }
        .onAppear {
            Task {
                viewModel.getSavedCards()
            }
        }
    }
}

struct SavedCardsDataView: View {
    let cards: [Card]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(cards, id: \.id) { card in
                        CardView(isFromSavedCardView: true, card: card)
                    }
                }
                .navigationTitle("Saved Cards")
            }
        }
    }
}

#Preview {
    SavedCardsView()
}
