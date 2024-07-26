import Foundation

public struct Cards: Codable, Equatable {
    let id: Int
    let uid: String
    let credit_card_number: String
    let credit_card_expiry_date: String
    let credit_card_type: CardType
}
