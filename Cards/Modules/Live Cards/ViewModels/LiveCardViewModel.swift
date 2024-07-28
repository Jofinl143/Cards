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
//        case let (.error(lhsError), .error(rhsError)):
//            return lhsError.localizedDescription == rhsError.localizedDescription
//        case let (.loaded(lhsCards), .loaded(rhsCards)):
//            return lhsCards == rhsCards
        default:
            return false
        }
    }
}

class LiveCardViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let cardRepository = CardRepository()
    @Published var liveCardsViewState: LiveCardsViewState = .loading
    @Published var showCardSavedAlert: Bool = false
    
    var db: DBHelper = DBHelper()
    
//    func fetchCards() {
//        cardRepository.fetchCards()
//            .catch { error in
//                Just([])
//            }
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    print("finished")
//                case .failure(let error):
//                    print("Token error", error)
//                }
//            }) { [weak self] cards in
//                if cards.isEmpty {
//                    self?.liveCardsViewState = .error
//                } else {
//                    
//                    let groupedCards = Dictionary(grouping: cards) { $0.credit_card_type }
//                    let cardsGroupedByType: [String : [Card]] = Dictionary(grouping: cards, by: { $0.credit_card_type })
//                    let sortedCardsGroupedByType: [Dictionary<String, [Card]>.Element] = cardsGroupedByType.sorted(by: { $0.0 < $1.0 })
//                    
//                    self?.liveCardsViewState = .loaded(sortedCardsGroupedByType)
////                    print(groupedCards)
//                }
//            }
//            .store(in: &cancellables)
//    }
    
    func fetchCards() {
        cardRepository.fetchData { [weak self] (result: Result<[Card], Error>) in
            switch result {
            case .success(let cards):
                if cards.isEmpty {
                    self?.liveCardsViewState = .error
                } else {
                    
                    var cachedCards = cards
                    if let savedCards = self?.db.read() {
                        var newCard: Card?
                        for card in cachedCards {
                            print(card.uid)
                            for savedCard in savedCards {
                                if card.id == savedCard.id {
                                    print(card)
//                                    newCard = card
//                                    newCard?.isCardSaved = 1
                                }
                            }
//                            var newCard: Card?
//                            for savedCard in savedCards {
//                                if card.uid == savedCard.uid {
//                                    newCard = card
//                                    newCard?.isCardSaved = 1
//                                }
//                            }
//                            if let card = newCard, let index = cachedCards.firstIndex(of: card) {
//                                cachedCards[index] = card
//                            }
                        }
                    }
                    // Grouping cards according to type
                    let cardsGroupedByType: [String : [Card]] = Dictionary(grouping: cachedCards, by: { $0.credit_card_type })
                    
                    // Sorting the grouped cards Alphabbetically
                    let sortedCardsGroupedByType: [Dictionary<String, [Card]>.Element] = cardsGroupedByType.sorted(by: { $0.0 < $1.0 })
                    DispatchQueue.main.async {
                        self?.liveCardsViewState = .loaded(sortedCardsGroupedByType)
                    }
                    //                    print(groupedCards)
                }
            case .failure:
                self?.liveCardsViewState = .error
            }
        }
    }
    
    func saveCard(card: Card) {
        guard let cards = db.read(), cards.contains(where: { $0.id != card.id }) else {
            return
        }
        
        showCardSavedAlert = db.insert(id: card.id, uid: card.uid, credit_card_number: card.credit_card_number, credit_card_expiry_date: card.credit_card_expiry_date, credit_card_type: card.credit_card_type, isCardSaved: 1)

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
        print("db count \(db.read())")
    }
    
    func deleteCard(card: Card) {
        db.deleteCardByID(id: card.id)
    }
}
