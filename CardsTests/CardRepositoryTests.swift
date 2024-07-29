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
            case .success(let card):
                XCTAssertNotNil(card)
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}

