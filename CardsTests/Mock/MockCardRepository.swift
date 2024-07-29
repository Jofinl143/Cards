import Foundation
@testable import Cards

class MockCardRepository: NetworkingService {
    
    func fetchData<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        // Mock the data and response here (e.g., create a sample JSON response)
        let jsonString = """
            [{
                "id": 1,
                "uid": "testUid1",
                "credit_card_number": "testCardNumber1",
                "credit_card_expiry_date": "testExpiry1",
                "credit_card_type": "testType1"
            }, {
                "id": 2,
                "uid": "testUid2",
                "credit_card_number": "testCardNumber2",
                "credit_card_expiry_date": "testExpiry2",
                "credit_card_type": "testType2"
            }, {
                "id": 3,
                "uid": "testUid3",
                "credit_card_number": "testCardNumber3",
                "credit_card_expiry_date": "testExpiry3",
                "credit_card_type": "testType3"
            }]
        """
        let jsonData = jsonString.data(using: .utf8)!
        if let object = try? JSONDecoder().decode(T.self, from: jsonData) {
            completion(.success(object))
        } else {
            let error = NSError(domain:"", code: 400, userInfo:nil)
            completion(.failure(error))
        }
    }
}
