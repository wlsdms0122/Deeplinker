//
//  DeeplinkerTests.swift
//
//
//  Created by jsilver on 2022/09/09.
//

import XCTest
@testable import Deeplinker

final class DeeplinkerTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func test_deeplink_should_handle_when_url_matches_pattern() {
        // Given
        let urls: [URL] = [
            URL(string: "deeplinker://a/b/c")!,
            URL(string: "deeplinker://a/b/c/")!,
            URL(string: "deeplinker://a/b/c/?")!,
            URL(string: "deeplinker://a/b/c/?d")!,
            URL(string: "deeplinker://a/b/c/?d=")!,
            URL(string: "deeplinker://a/b/c/?d=e")!,
            URL(string: "deeplinker://a/b/c?d")!,
            URL(string: "deeplinker://a/b/c?d=")!,
            URL(string: "deeplinker://a/b/c?d=e")!
        ]
        
        let deeplinker = Deeplinker(canHandle: true)
        
        deeplinker.addURL("deeplinker://a/b/c") { _, _, _ in }
        
        // When
        let result = urls.allSatisfy { deeplinker.handle(url: $0) }
        
        // Then
        XCTAssertTrue(result)
    }
    
    func test_deeplink_should_not_handle_when_url_not_matches_pattern() {
        // Given
        let urls: [URL] = [
            URL(string: "scheme://a/b/c")!,
            URL(string: "deeplinker://a/b")!,
            URL(string: "deeplinker://a/b/")!,
            URL(string: "deeplinker://a/b/c/d")!,
            URL(string: "deeplinker://d/e/f")!
        ]
        
        let deeplinker = Deeplinker(canHandle: true)
        
        deeplinker.addURL("deeplinker://a/b/c") { _, _, _ in }
        
        // When
        let result = urls.allSatisfy { !deeplinker.handle(url: $0) }
        
        // Then
        XCTAssertTrue(result)
    }
    
    func test_deeplink_should_handle_when_url_matches_pattern_with_parameter() {
        // Given
        let urls: [URL] = [
            URL(string: "deeplinker://a/b/c")!,
            URL(string: "deeplinker://a/b/c/")!,
            URL(string: "deeplinker://a/b/c/?")!,
            URL(string: "deeplinker://a/b/c/?d")!,
            URL(string: "deeplinker://a/b/c/?d=")!,
            URL(string: "deeplinker://a/b/c/?d=e")!,
            URL(string: "deeplinker://a/b/c?d")!,
            URL(string: "deeplinker://a/b/c?d=")!,
            URL(string: "deeplinker://a/b/c?d=e")!
        ]
        
        let deeplinker = Deeplinker(canHandle: true)
        
        deeplinker.addURL("deeplinker://a/b/:path") { _, parameter, _ in
            XCTAssertNotNil(parameter["path"])
        }
        
        // When
        let result = urls.allSatisfy { deeplinker.handle(url: $0) }
        
        // Then
        XCTAssertTrue(result)
    }
}
