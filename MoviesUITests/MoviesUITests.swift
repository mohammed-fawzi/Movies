//
//  MoviesUITests.swift
//  MoviesUITests
//
//  Created by Mohamed Fawzy on 01/08/2024.
//

import XCTest
@testable import PresentationLayer

final class MoviesUITests: XCTestCase {
  var app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testMovieCellExists() throws {
        let ids = AccessibilityIds.MovieCardView.self
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.exists)
        XCTAssertTrue(firstCell.staticTexts[ids.titleLabel.rawValue].exists)
        XCTAssertTrue(firstCell.images[ids.posterImage.rawValue].exists)
        XCTAssertTrue(firstCell.staticTexts[ids.releaseDateLabel.rawValue].exists)
        XCTAssertTrue(firstCell.staticTexts[ids.scoreLabel.rawValue].exists)
        XCTAssertTrue(firstCell.images[ids.scoreIcon.rawValue].exists)
    }
    
    func testTabBarTabsExistsWithCorrentName(){
        let tabs = app.tabBars.buttons
        let firstTab = tabs.element(boundBy: 0)
        let secondTab = tabs.element(boundBy: 1)
        let thidTab = tabs.element(boundBy: 2)
        
        XCTAssertEqual(firstTab.label, "Trending")
        XCTAssertEqual(secondTab.label, "Now Playing")
        XCTAssertEqual(thidTab.label, "Upcoming")
    }
    
    func testTabBarTabsNavigation(){
        let tabs = app.tabBars.buttons
        let firstTab = tabs.element(boundBy: 0)
        let secondTab = tabs.element(boundBy: 1)
        let thidTab = tabs.element(boundBy: 2)
        
        let navigationBar = app.navigationBars.element
        
        firstTab.tap()
        XCTAssertTrue(navigationBar.staticTexts["Trending"].exists)
        secondTab.tap()
        XCTAssertTrue(navigationBar.staticTexts["Now Playing"].exists)
        thidTab.tap()
        XCTAssertTrue(navigationBar.staticTexts["Upcoming"].exists)
    }
  
    func testNavigateToDetailsScreen(){
        let ids = AccessibilityIds.MovieDetailsView.self
        app.cells.firstMatch.tap()
        XCTAssertTrue(app.staticTexts[ids.detailsGenresLabel.rawValue].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts[ids.detailsOverviewTextView.rawValue].exists)
        XCTAssertTrue(app.images[ids.detailsPosterImage.rawValue].exists)
    }
    
    func testSearch(){
        // activate search
        let ids = AccessibilityIds.MovieCardView.self
        let list = app.collectionViews.firstMatch
        let searchField = app.searchFields.element
        searchField.tap()
        // get third cell title
        let thirdCellTitle = list.cells.element(boundBy: 2).staticTexts[ids.titleLabel.rawValue].label
        // search for third cell
        searchField.typeText(thirdCellTitle)
        app.keyboards.firstMatch.buttons["Search"].firstMatch.tap()
        //first search result now should be same as what we have typed
        let firstCellTitle = list.cells.firstMatch.staticTexts[ids.titleLabel.rawValue].label
        XCTAssertEqual(firstCellTitle, thirdCellTitle)
    }
    
    func testFilters(){
        //select action filter
        let actionFilter = app.buttons["Action"]
        actionFilter.tap()
        //navigate to first movie
        app.cells.firstMatch.tap()
        //genres should contain "Action" word
        XCTAssertTrue(app.staticTexts["detailsGenresLabel"].label.contains("Action"))
    }
    
}

