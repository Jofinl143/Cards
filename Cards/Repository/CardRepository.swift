import Foundation
import Combine

enum APIError: LocalizedError {
    /// Invalid request, e.g. invalid URL
    case invalidRequestError(String)
    
    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case transportError(Error)
}

protocol NetworkingService {
    func fetchData<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void)
}

class CardRepository: NetworkingService {
            
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

    func fetchCards() -> AnyPublisher<[Card], Error> {
        guard let url =
                URL(string: "https://random-data-api.com/api/v2/credit_cards?size=100") else {
            return Fail(error: APIError.invalidRequestError("URL invalid"))
                .eraseToAnyPublisher()
        }        
        let request = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError({ error in
                return APIError.transportError(error)
            })
            .map(\.data)
            .decode(type: [Card].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
}
