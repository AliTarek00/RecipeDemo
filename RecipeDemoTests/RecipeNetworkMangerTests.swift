//
//  RecipeDemoTests.swift
//  RecipeDemoTests
//
//  Created by Ali Tarek on 6/10/21.
//

import XCTest
@testable import RecipeDemo

class RecipeDemoTests: XCTestCase {
    
    var networkManager: RecipeNetworkManager!
    
    override func setUpWithError() throws
    {
        networkManager = RecipeNetworkManager(type: .test)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchSearchResults() throws
    {
        let expectedNumberOSearchfResults = 1
        var exactNumberOfSearchResults: Int?
        
        networkManager.search(query: "chiken", filter: nil, from: 0, to: 1) { result in
            if case .success(let response) = result
            {
                exactNumberOfSearchResults = response.data?.count ?? 0
            }
        }
        
        let message = "expected: \(expectedNumberOSearchfResults), exact: \(String(describing: exactNumberOfSearchResults))"
        XCTAssert(expectedNumberOSearchfResults == exactNumberOfSearchResults, message)
    }
}
