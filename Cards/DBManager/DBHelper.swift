import Foundation
import SQLite3

class DBHelper {
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    // Create Table in the DB
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS CARD(Id INTEGER PRIMARY KEY,uid TEXT,creditCardNumber TEXT,creditCardExpiryDate TEXT,creditCardType TEXT, isCardSaved INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("card table created.")
            } else {
                print("card table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    // Inser data to table
    func insert(id: Int, uid: String, credit_card_number: String, credit_card_expiry_date: String, credit_card_type: String, isCardSaved: Int) -> Bool {
        
        let insertStatementString = "INSERT INTO CARD (Id, uid, creditCardNumber, creditCardExpiryDate, creditCardType, isCardSaved) VALUES (?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (uid as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (credit_card_number as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (credit_card_expiry_date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (credit_card_type as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 6, Int32(isCardSaved))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                return true
            } else {
                print("Could not insert row.")
                return false
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        return false
    }
    
    // Read data from the table
    func read() -> [Card]? {
        let queryStatementString = "SELECT * FROM CARD;"
        var queryStatement: OpaquePointer? = nil
        var cards : [Card] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let uid = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let credit_card_number = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let credit_card_expiry_date = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let credit_card_type = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let isCardSaved = sqlite3_column_int(queryStatement, 5)
                cards.append(Card(id: Int(id), uid: uid, credit_card_number: credit_card_number, credit_card_expiry_date: credit_card_expiry_date, credit_card_type: credit_card_type, isCardSaved: isCardSaved))
                print("Query Result:")
                print("\(id) | \(uid) | \(credit_card_number) | \(credit_card_expiry_date)| \(credit_card_type)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return cards
    }
    
    // Delete card by ID from table
    func deleteCardByID(id: Int) {
        let deleteStatementStirng = "DELETE FROM CARD WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    // Delete all rows from table
    func deleteAllRows() {
        let deleteStatementString = "DELETE FROM CARD;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted all rowns from CARD")
            } else {
                print("Could not delete all rowns from CARD")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
