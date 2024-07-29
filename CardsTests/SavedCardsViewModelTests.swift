import XCTest
@testable import Cards

final class CardsTests: XCTestCase {

    var savedCardsViewModel: SavedCardsViewModel?
    var db: DBHelper = DBHelper()
    var cards: [Card]!
    
    override func setUpWithError() throws {
        savedCardsViewModel = SavedCardsViewModel()
        db.deleteAllRows()
        
        let card1 = Card(
            id: 1,
            uid: "testUid1",
            credit_card_number: "testCardNumber1",
            credit_card_expiry_date: "testExpiry1",
            credit_card_type: "testType1",
            isCardSaved: 1
        )

        let card2 = Card(
            id: 2,
            uid: "testUid2",
            credit_card_number: "testCardNumber2",
            credit_card_expiry_date: "testExpiry2",
            credit_card_type: "testType2",
            isCardSaved: 1
        )

        let card3 = Card(
            id: 3,
            uid: "testUid3",
            credit_card_number: "testCardNumber3",
            credit_card_expiry_date: "testExpiry3",
            credit_card_type: "testType3",
            isCardSaved: 1
        )
        
        cards = [card1, card2, card3]
        
        for card in cards {
            _ = db.insert(
                id: card.id,
                uid: card.uid,
                credit_card_number: card.credit_card_number,
                credit_card_expiry_date: card.credit_card_expiry_date,
                credit_card_type: card.credit_card_type,
                isCardSaved: 1
            )
        }
    }

    func testGetSavedCardsLoaded() {
        // When initial state is loading
        XCTAssertEqual(savedCardsViewModel?.savedCardsViewState, .loading)
        
        // Calling saved cards
        savedCardsViewModel?.getSavedCards()
        
        // Then sate should be loaded
        XCTAssertEqual(savedCardsViewModel?.savedCardsViewState, .loaded(cards))
    }
    
    func testGetSavedCardsFailed() {
        // When initial state is loading
        XCTAssertEqual(savedCardsViewModel?.savedCardsViewState, .loading)
        
        // And no cards saved
        db.deleteAllRows()
        
        // Calling saved cards
        savedCardsViewModel?.getSavedCards()
        
        // Then sate should be error
        XCTAssertEqual(savedCardsViewModel?.savedCardsViewState, SavedCardsViewState.error)
    }
    
    override func tearDownWithError() throws {
        db.deleteAllRows()
    }
}
