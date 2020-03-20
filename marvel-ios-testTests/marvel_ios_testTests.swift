//
//  marvel_ios_testTests.swift
//  marvel-ios-testTests
//
//  Created by Zachary Esmaelzada on 3/18/20.
//  Copyright © 2020 Zachary Esmaelzada. All rights reserved.
//

import XCTest
@testable import marvel_ios_test

class marvel_ios_testTests: XCTestCase {
    
    var sut: URLSession!

    override func setUp() {
        super.setUp()
        sut = URLSession(configuration: .default)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testComicDetailsEndpoint() {
        let comicId = 1994
        let url = URL(string: "https://gateway.marvel.com:443/v1/public/comics/\(comicId)?\(getCredentials())")
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sut.dataTask(with: url!) { data, response, error in
          if let error = error {
            XCTFail("Error: \(error.localizedDescription)")
            return
          } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode == 200 {
              promise.fulfill()
            } else {
              XCTFail("Status code: \(statusCode)")
            }
          }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
    
    private func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5("\(ts)\(MarvelAPIKey.privateKey)\(MarvelAPIKey.publicKey)").lowercased()
        return "apikey=\(MarvelAPIKey.publicKey)&hash=\(hash)&ts=\(ts)"
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
