import Foundation
import SwiftUI
import Combine

enum LiveCardsViewState: Equatable {
    case loading
    case loaded([Dictionary<String, [Card]>.Element])
    case error
    
    static func == (lhs: LiveCardsViewState, rhs: LiveCardsViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

class LiveCardsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var cardRepository: NetworkingService
    
    @Published var liveCardsViewState: LiveCardsViewState = .loading
    @Published var showCardSavedAlert: Bool = false
    
    var showCardSavedAlertMessage: String = "Your card is saved"
    var db: DBHelper = DBHelper()
    
    init(cardRepository: NetworkingService = CardRepository()) {
        self.cardRepository = cardRepository
    }
    
    func fetchCards() {
        cardRepository.fetchData { [weak self] (result: Result<[Card], Error>) in
            switch result {
            case .success(let cards):
                if cards.isEmpty {
                    DispatchQueue.main.async {
                        self?.liveCardsViewState = .error
                    }
                } else {
                    
                    let cachedCards = cards
                    // Grouping cards according to type
                    let cardsGroupedByType: [String : [Card]] = Dictionary(grouping: cachedCards, by: { $0.credit_card_type })
                    
                    // Sorting the grouped cards Alphabbetically
                    let sortedCardsGroupedByType: [Dictionary<String, [Card]>.Element] = cardsGroupedByType.sorted(by: { $0.0 < $1.0 })
                    DispatchQueue.main.async {
                        self?.liveCardsViewState = .loaded(sortedCardsGroupedByType)
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.liveCardsViewState = .error
                }
            }
        }
    }
    
    func saveCard(card: Card) {
        if let cards = db.read(), !cards.isEmpty, cards.contains(where: { $0.id == card.id }) {
            showCardSavedAlert = true
            showCardSavedAlertMessage = "Card already saved"
            return
        }
        
        showCardSavedAlert = db.insert(id: card.id, uid: card.uid, credit_card_number: card.credit_card_number, credit_card_expiry_date: card.credit_card_expiry_date, credit_card_type: card.credit_card_type, isCardSaved: 1)
        Task { @MainActor in
        if case let .loaded(cardDetails) = liveCardsViewState {
            var cachedCardDetails = cardDetails
            guard var cardTypeArray = cachedCardDetails.first(where: { $0.key == card.credit_card_type }), let itemIndex = cachedCardDetails.firstIndex(where: { $0.key == card.credit_card_type } ) else {
                return
            }
            var filtered = cardTypeArray.value
            var newCard: Card?
            var index = 0
            for item in filtered {
                if card.id == item.id {
                    index = filtered.firstIndex(of: item) ?? 0
                    newCard = item
                    newCard?.isCardSaved = 1
                }
            }
            if let card = newCard {
                filtered[index] = card
            }
            cardTypeArray.value = filtered
            cachedCardDetails[itemIndex] = cardTypeArray
                liveCardsViewState = .loaded(cachedCardDetails)
            }
        }
    }
    
    func deleteCard(card: Card) {
        db.deleteCardByID(id: card.id)
    }
}
