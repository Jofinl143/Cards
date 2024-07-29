import Foundation
import Combine

protocol NetworkingService {
    func fetchData<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void)
}

class CardRepository: NetworkingService {
    
    // A generic fetch method to fetch any type for data
    func fetchData<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        guard let url =
                URL(string: "https://random-data-api.com/api/v2/credit_cards?size=100") else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(object))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}
