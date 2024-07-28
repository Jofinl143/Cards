import Foundation

enum SavedCardsViewState: Equatable {
    case loading
    case loaded([Card])
    case error

    static func == (lhs: SavedCardsViewState, rhs: SavedCardsViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
//        case let (.error(lhsError), .error(rhsError)):
//            return lhsError.localizedDescription == rhsError.localizedDescription
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
    
    init() {
        savedCardsViewState = .loading
        getSavedCards()
    }
    
    func getSavedCards() {
        if db.read().count > 0 {
            savedCardsViewState = .loaded(db.read())
        } else {
            savedCardsViewState = .error
        }
    }
        
    func deleteCard(card: Card) {
        db.deleteCardByID(id: card.id)
        getSavedCards()
    }
}
