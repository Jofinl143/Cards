import XCTest

final class CardsUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveCard() throws {
        
        app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element/*@START_MENU_TOKEN@*/.children(matching: .button).matching(identifier: "nameText-addOrRemoveImage-cardNumberText-cardTypeText-expiryText").element(boundBy: 1).images["addOrRemoveImage"]/*[[".children(matching: .button).matching(identifier: \"Nicolas Martin, 1228-1221-1221-1431, american_express, 2026-07-29\").element(boundBy: 1)",".images[\"Add\"]",".images[\"addOrRemoveImage\"]",".children(matching: .button).matching(identifier: \"nameText-addOrRemoveImage-cardNumberText-cardTypeText-expiryText\").element(boundBy: 1)"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        
        app.alerts["Your card is saved"].scrollViews.otherElements.buttons["OK"].tap()
    }

}
