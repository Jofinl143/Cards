import Foundation

public struct Card: Codable, Equatable, Comparable, Hashable {
    public static func < (lhs: Card, rhs: Card) -> Bool {
        return lhs == rhs
    }
    
    let id: Int
    let uid: String
    let credit_card_number: String
    let credit_card_expiry_date: String
    let credit_card_type: String
    var isCardSaved: Int32? // isCardSaved used to check the card is saved or not and inserted toSQLite3 DB. Datatype Int is used because SQLite3 db doesnt support Bool
}
