import XCTest
@testable import Cards

final class LiveCardsViewModelTests: XCTestCase {
    
    var liveCardsViewModel: LiveCardsViewModel?
    var db: DBHelper = DBHelper()
    var cards: [Card]!
    
    override func setUpWithError() throws {
        let mockCardRepository = MockCardRepository()
        liveCardsViewModel = LiveCardsViewModel(cardRepository: mockCardRepository)
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
        
    }
    
    override func tearDownWithError() throws {
        db.deleteAllRows()
    }
    
    func testSaveCardSuccess() {
        // When initial state is loading
        XCTAssertEqual(liveCardsViewModel?.liveCardsViewState, .loading)
        
        let card1 = Card(
            id: 1,
            uid: "testUid1",
            credit_card_number: "testCardNumber1",
            credit_card_expiry_date: "testExpiry1",
            credit_card_type: "testType1",
            isCardSaved: 1
        )
        
        liveCardsViewModel?.saveCard(card: card1)
        
        // Then sate should be loaded
        XCTAssertNotNil(liveCardsViewModel?.liveCardsViewState)
        XCTAssertEqual(liveCardsViewModel?.showCardSavedAlert, true)
        
        // And db has a value
        XCTAssertEqual(db.read(), [card1])
        
    }
    
    func testSaveCardFailed() {
        // When initial state is loading
        XCTAssertEqual(liveCardsViewModel?.liveCardsViewState, .loading)
        
        // Insert card to DB
        let card1 = Card(
            id: 1,
            uid: "testUid1",
            credit_card_number: "testCardNumber1",
            credit_card_expiry_date: "testExpiry1",
            credit_card_type: "testType1",
            isCardSaved: 1
        )
        
        // Insert same card to DB
        _ = db.insert(
            id: card1.id,
            uid: card1.uid,
            credit_card_number: card1.credit_card_number,
            credit_card_expiry_date: card1.credit_card_expiry_date,
            credit_card_type: card1.credit_card_type,
            isCardSaved: 1
        )
        
        liveCardsViewModel?.saveCard(card: card1)
        
        // Then we get the first card only
        let card = db.read()?.first
        XCTAssertEqual(db.read()?.count, 1)
        XCTAssertEqual(card?.id, 1)
        XCTAssertEqual(card?.uid, "testUid1")
        XCTAssertEqual(card?.credit_card_number, "testCardNumber1")
        XCTAssertEqual(card?.credit_card_type, "testType1")
        XCTAssertEqual(card?.credit_card_expiry_date, "testExpiry1")
    }
}
