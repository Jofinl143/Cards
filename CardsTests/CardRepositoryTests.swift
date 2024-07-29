import XCTest
@testable import Cards

class CardRepositoryTests: XCTestCase {
    var cardRepository: MockCardRepository!
    
    override func setUpWithError() throws {
        cardRepository = MockCardRepository()
    }
    
    override func tearDownWithError() throws {
        cardRepository = nil
    }
    
    func testFetchMovieDataSuccess() {
        let expectation = self.expectation(description: "Fetch card data")
        cardRepository.fetchData { (result: Result<[Card], Error>) in
            switch result {
            case .success(let cards):
                
                XCTAssertNotNil(cards)
                
                let card = cards.first
                XCTAssertEqual(card?.id, 1)
                XCTAssertEqual(card?.uid, "testUid1")
                XCTAssertEqual(card?.credit_card_number, "testCardNumber1")
                XCTAssertEqual(card?.credit_card_expiry_date, "testExpiry1")
                XCTAssertEqual(card?.credit_card_type, "testType1")
                
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCardDataFailed() {
        let expectation = self.expectation(description: "Fetch card data")
        cardRepository.jsonString = ""
        cardRepository.fetchData { (result: Result<[Card], Error>) in

            if case .failure(let failure) = result {
                XCTAssertNotNil(failure)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
}

