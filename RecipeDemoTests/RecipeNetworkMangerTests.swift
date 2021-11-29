//
//  RecipeDemoTests.swift
//  RecipeDemoTests
//
//  Created by Ali Tarek on 6/10/21.
//

import XCTest
@testable import RecipeDemo

class RecipeDemoTests: XCTestCase
{
    // MARK:- SUT
    
    var networkManager: RecipeNetworkManager!
    
    // MARK:- Test LifeCycle Methods

    override func setUpWithError() throws
    {
        networkManager = RecipeNetworkManager(type: .test)
    }
    
    override func tearDownWithError() throws
    {
    }
    
    // MARK:- Test Methods

    func testFetchSearchResults() throws
    {
        let expectedNumberOSearchfResults = 1
        var exactNumberOfSearchResults: Int?
        let request = SearchRequest(query: "chiken", filter: nil, from: 0, to: 1)
        _ = networkManager.search(request: request)
            .sink { _ in
            } receiveValue: { response in
                exactNumberOfSearchResults = response.data?.count ?? 0
            }
        
        let message = "expected: \(expectedNumberOSearchfResults), exact: \(String(describing: exactNumberOfSearchResults))"
        XCTAssert(expectedNumberOSearchfResults == exactNumberOfSearchResults, message)
    }
}
