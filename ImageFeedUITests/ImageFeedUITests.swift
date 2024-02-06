//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Dmitry Markovskiy on 04.02.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    enum PersonalDataForTests {
        static let email = "markovskii-dmitrii@yandex.ru"
        static let passwd = "Ramzes-king20"
        static let fullName = "Dmitrii Markovskii"
        static let login = "markovsdima" //without @
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 3))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 3))
        
        loginTextField.tap()
        sleep(2)
        loginTextField.typeText(PersonalDataForTests.email)
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
        
        passwordTextField.tap()
        sleep(2)
        passwordTextField.typeText(PersonalDataForTests.passwd)
        sleep(2)
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        sleep(3)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["Like Inactive"].tap()
        sleep(1)
        cellToLike.buttons["Like Active"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1) // zoom in
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[PersonalDataForTests.fullName].exists)
        XCTAssertTrue(app.staticTexts["@\(PersonalDataForTests.login)"].exists)
        
        app.buttons["LogoutButton"].tap()
        
        app.alerts["LogoutAlert"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
