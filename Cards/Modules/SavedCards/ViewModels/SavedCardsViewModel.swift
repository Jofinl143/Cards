import Foundation

enum SavedCardsViewState: Equatable {
    case loading
    case loaded([Card])
    case error
    
    static func == (lhs: SavedCardsViewState, rhs: SavedCardsViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.error, .error):
            return true
        case let (.loaded(lhsCards), .loaded(rhsCards)):
            return lhsCards == rhsCards
        default:
            return false
        }
    }
}

class SavedCardsViewModel: ObservableObject {
    @Published var savedCardsViewState: SavedCardsViewState = .loading
    
    var db: DBHelper = DBHelper()
    
    func getSavedCards() {
        guard let cards = db.read(), cards.count > 0 else {
            savedCardsViewState = .error
            return
        }
        savedCardsViewState = .loaded(cards)
    }
    
    func deleteCard(card: Card) {
        savedCardsViewState = .loading
        db.deleteCardByID(id: card.id)
        getSavedCards()
    }
    
}
