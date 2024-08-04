//
//  MoviesUITests.swift
//  MoviesUITests
//
//  Created by Mohamed Fawzy on 01/08/2024.
//

import XCTest

final class MoviesUITests: XCTestCase {
  var app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testMovieCellExists() throws {
        let firstCell = app.tables.cells.firstMatch
        XCTAssertTrue(firstCell.exists)
        XCTAssertTrue(firstCell.staticTexts["titleLabel"].exists)
        XCTAssertTrue(firstCell.images["posterImage"].exists)
        XCTAssertTrue(firstCell.staticTexts["releaseDateLabel"].exists)
        XCTAssertTrue(firstCell.staticTexts["scoreLabel"].exists)
        XCTAssertTrue(firstCell.images["scoreIcon"].exists)
    }
    
    func testTabBarTabsExistsWithCorrentName(){
        let tabs = app.tabBars.buttons
        let firstTab = tabs.element(boundBy: 0)
        let secondTab = tabs.element(boundBy: 1)
        let thidTab = tabs.element(boundBy: 2)
        
        XCTAssertEqual(firstTab.label, "Trending")
        XCTAssertEqual(secondTab.label, "Now playing")
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
        XCTAssertTrue(navigationBar.staticTexts["Now playing"].exists)
        thidTab.tap()
        XCTAssertTrue(navigationBar.staticTexts["Upcoming"].exists)
    }
  
    func testNavigateToDetailsScreen(){
        app.tables.cells.firstMatch.tap()
        let detailsView = app.otherElements["movieDetailsScreen"]
        XCTAssertTrue(detailsView.staticTexts["detailsGenresLabel"].exists)
        XCTAssertTrue(detailsView.textViews["detailsOverviewTextView"].exists)
        XCTAssertTrue(detailsView.images["detailsPosterImage"].exists)
        let tagsCollection = detailsView.collectionViews["tagsCollectionView"]
        XCTAssertTrue(tagsCollection.exists)
        XCTAssertEqual(tagsCollection.cells.count, 4)
    }
    
    func testSearch(){
        // activate search
        let table = app.tables.firstMatch
        let searchField = app.searchFields.element
        searchField.tap()
        // get third cell title
        let thirdCellTitle = table.cells.element(boundBy: 3).staticTexts["titleLabel"].label
        // search for third cell
        searchField.typeText(thirdCellTitle)
        app.keyboards.firstMatch.buttons["Search"].firstMatch.tap()
        //first search result now should be same as what we have typed
        let firstCellTitle = table.cells.firstMatch.staticTexts["titleLabel"].label
        XCTAssertEqual(firstCellTitle, thirdCellTitle)
        app.tables.cells.firstMatch.tap()
        
    }
    
    func testFilters(){
        //select action filter
        let filters = app.collectionViews.firstMatch
        let actionFilter = filters.cells.staticTexts["Action"]
        actionFilter.tap()
        //navigate to first movie
        app.tables.cells.firstMatch.tap()
        //genres should contain "Action" word
        let detailsView = app.otherElements["movieDetailsScreen"]
        XCTAssertTrue(detailsView.staticTexts["detailsGenresLabel"].label.contains("Action"))
    }
    
}

