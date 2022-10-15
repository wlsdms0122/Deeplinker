//
//  Deeplink.swift
//  
//
//  Created by jsilver on 2022/10/12.
//

import XCTest
@testable import Deeplinker

final class DeeplinkTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func test_that_deeplink_should_match_when_url_matches_pattern() {
        // Given
        let urls = [
            URL(string: "deeplinker://a/b")!,
            URL(string: "deeplinker://a/b?")!,
            URL(string: "deeplinker://a/b?c")!,
            URL(string: "deeplinker://a/b?c=")!,
            URL(string: "deeplinker://a/b?c=d")!,
            URL(string: "deeplinker://a/b/")!,
            URL(string: "deeplinker://a/b/?")!,
            URL(string: "deeplinker://a/b/?c")!,
            URL(string: "deeplinker://a/b/?c=")!,
            URL(string: "deeplinker://a/b/?c=d")!
        ]
        
        guard let sut = Deeplink(
            url: "deeplinker://a/b",
            action: { _, _, _ in true }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        urls.forEach {
            // When
            let result = sut.matches(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was mismatched."
            )
        }
    }
    
    func test_that_deeplink_url_that_include_slash_path_on_last_should_match_when_url_matches_pattern() {
        // Given
        let urls = [
            URL(string: "deeplinker://a/b")!,
            URL(string: "deeplinker://a/b?")!,
            URL(string: "deeplinker://a/b?c")!,
            URL(string: "deeplinker://a/b?c=")!,
            URL(string: "deeplinker://a/b?c=d")!,
            URL(string: "deeplinker://a/b/")!,
            URL(string: "deeplinker://a/b/?")!,
            URL(string: "deeplinker://a/b/?c")!,
            URL(string: "deeplinker://a/b/?c=")!,
            URL(string: "deeplinker://a/b/?c=d")!
        ]
        
        guard let sut = Deeplink(
            url: "deeplinker://a/b/",
            action: { _, _, _ in true }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        urls.forEach {
            // When
            let result = sut.matches(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was mismatched."
            )
        }
    }
    
    func test_that_deeplink_url_that_include_query_should_match_when_url_matches_pattern() {
        // Given
        let urls = [
            URL(string: "deeplinker://a/b")!,
            URL(string: "deeplinker://a/b?")!,
            URL(string: "deeplinker://a/b?c")!,
            URL(string: "deeplinker://a/b?c=")!,
            URL(string: "deeplinker://a/b?c=d")!,
            URL(string: "deeplinker://a/b/")!,
            URL(string: "deeplinker://a/b/?")!,
            URL(string: "deeplinker://a/b/?c")!,
            URL(string: "deeplinker://a/b/?c=")!,
            URL(string: "deeplinker://a/b/?c=d")!
        ]
        
        guard let sut = Deeplink(
            url: "deeplinker://a/b?key=value",
            action: { _, _, _ in true }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        urls.forEach {
            // When
            let result = sut.matches(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was mismatched."
            )
        }
    }
    
    func test_that_deeplink_url_that_include_slash_path_on_last_and_query_should_match_when_url_matches_pattern() {
        // Given
        let urls = [
            URL(string: "deeplinker://a/b")!,
            URL(string: "deeplinker://a/b?")!,
            URL(string: "deeplinker://a/b?c")!,
            URL(string: "deeplinker://a/b?c=")!,
            URL(string: "deeplinker://a/b?c=d")!,
            URL(string: "deeplinker://a/b/")!,
            URL(string: "deeplinker://a/b/?")!,
            URL(string: "deeplinker://a/b/?c")!,
            URL(string: "deeplinker://a/b/?c=")!,
            URL(string: "deeplinker://a/b/?c=d")!
        ]
        
        guard let sut = Deeplink(
            url: "deeplinker://a/b/?key=value",
            action: { _, _, _ in true }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        urls.forEach {
            // When
            let result = sut.matches(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was mismatched."
            )
        }
    }
    
    func test_that_deeplink_should_not_match_when_url_mismatches_pattern() {
        // Given
        let urls = [
            URL(string: "scheme://a/b")!,
            URL(string: "deeplinker://a")!,
            URL(string: "deeplinker://a/")!,
            URL(string: "deeplinker://a/c")!,
            URL(string: "deeplinker://a/c/")!,
            URL(string: "deeplinker://a/b/c")!,
            URL(string: "deeplinker://a/b/c/")!
        ]
        
        guard let sut = Deeplink(
            url: "deeplinker://a/b",
            action: { _, _, _ in true }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        urls.forEach {
            // When
            let result = !sut.matches(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was mismatched."
            )
        }
    }
    
    func test_that_deeplink_that_include_path_parameter_should_match_when_url_matches_pattern() {
        // Given
        let urls = [
            URL(string: "deeplinker://a/b")!,
            URL(string: "deeplinker://a/b?")!,
            URL(string: "deeplinker://a/b?c")!,
            URL(string: "deeplinker://a/b?c=")!,
            URL(string: "deeplinker://a/b?c=d")!,
            URL(string: "deeplinker://a/b/")!,
            URL(string: "deeplinker://a/b/?")!,
            URL(string: "deeplinker://a/b/?c")!,
            URL(string: "deeplinker://a/b/?c=")!,
            URL(string: "deeplinker://a/b/?c=d")!,
            URL(string: "deeplinker://a/c?")!,
            URL(string: "deeplinker://a/c?d")!,
            URL(string: "deeplinker://a/c?e=")!,
            URL(string: "deeplinker://a/c?e=f")!,
            URL(string: "deeplinker://a/c/")!,
            URL(string: "deeplinker://a/c/?")!,
            URL(string: "deeplinker://a/c/?e")!,
            URL(string: "deeplinker://a/c/?e=")!,
            URL(string: "deeplinker://a/c/?e=f")!,
        ]
        
        guard let sut = Deeplink(
            url: "deeplinker://a/:path",
            action: { _, _, _ in true }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        urls.forEach {
            // When
            let result = sut.matches(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was mismatched."
            )
        }
    }
    
    func test_that_deeplink_that_include_path_parameter_should_not_match_when_url_mismatches_pattern() {
        // Given
        let urls = [
            URL(string: "scheme://a/b")!,
            URL(string: "deeplinker://a")!,
            URL(string: "deeplinker://a/")!,
            URL(string: "deeplinker://a/b/c")!,
            URL(string: "deeplinker://a/b/c/")!
        ]
        
        guard let sut = Deeplink(
            url: "deeplinker://a/:path",
            action: { _, _, _ in true }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        urls.forEach {
            // When
            let result = sut.matches(url: $0)
            
            // Then
            XCTAssertFalse(
                result,
                "\($0.absoluteString) was matched."
            )
        }
    }
    
    func test_that_deeplink_url_that_invalid_foramt_should_not_instantiate() {
        // Given
        let urls = [
            "a/b", // Missing scheme. (nil)
            "://a/b", // Missing scheme. (empty)
            "deeplinker:///a", // Missing host. (nil)
            "deeplinker://:1004/a", // Missing host. (empty),
            "" // Invalid url format.
        ]
        
        // When
        urls.forEach {
            let sut = Deeplink(url: $0) { _, _, _ in true }
            
            // Then
            XCTAssertNil(
                sut,
                "Deeplink instantiate with invalid url. (\($0))"
            )
        }
    }
    
    func test_that_deeplink_that_instantiated_by_pattern_should_match_when_url_matches_pattern() {
        // Given
        let urls = [
            URL(string: "https://www.apple.com")!,
            URL(string: "http://www.google.com")!
        ]
        
        let sut = Deeplink(
            pattern: "(http|https)://.*",
            action: { _, _, _ in true }
        )
        
        urls.forEach {
            // When
            let result = sut.matches(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was mismatched."
            )
        }
    }
    
    func test_that_deeplink_should_action_when_url_matches_pattern() {
        // Given
        let urls = [
            URL(string: "deeplinker://a/b")!,
            URL(string: "deeplinker://a/b?")!,
            URL(string: "deeplinker://a/b?c")!,
            URL(string: "deeplinker://a/b?c=")!,
            URL(string: "deeplinker://a/b?c=d")!,
            URL(string: "deeplinker://a/b/")!,
            URL(string: "deeplinker://a/b/?")!,
            URL(string: "deeplinker://a/b/?c")!,
            URL(string: "deeplinker://a/b/?c=")!,
            URL(string: "deeplinker://a/b/?c=d")!
        ]
        
        guard let sut = Deeplink(
            url: "deeplinker://a/b",
            action: { _, _, _ in true }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        urls.forEach {
            // When
            let result = sut.action(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was mismatched."
            )
        }
    }
    
    func test_that_deeplink_should_not_action_when_url_mismatches_pattern() {
        // Given
        let urls = [
            URL(string: "scheme://a/b")!,
            URL(string: "deeplinker://a")!,
            URL(string: "deeplinker://a/")!,
            URL(string: "deeplinker://a/c")!,
            URL(string: "deeplinker://a/c/")!,
            URL(string: "deeplinker://a/b/c")!,
            URL(string: "deeplinker://a/b/c/")!
        ]
        
        guard let sut = Deeplink(
            url: "deeplinker://a/b",
            action: { _, _, _ in true }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        urls.forEach {
            // When
            let result = !sut.action(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was matched."
            )
        }
    }
    
    func test_that_deeplink_action_pass_url_parameter() {
        // Given
        let urls = [
            URL(string: "deeplinker://a/b")!,
            URL(string: "deeplinker://a/b?")!,
            URL(string: "deeplinker://a/b?d")!,
            URL(string: "deeplinker://a/b?d=")!,
            URL(string: "deeplinker://a/b?d=e")!,
            URL(string: "deeplinker://a/b/")!,
            URL(string: "deeplinker://a/b/?")!,
            URL(string: "deeplinker://a/b/?d")!,
            URL(string: "deeplinker://a/b/?d=")!,
            URL(string: "deeplinker://a/b/?d=e")!
        ]
        
        var results: [URL] = []
        
        guard let sut = Deeplink(
            url: "deeplinker://a/b",
            action: { url, _, _ in
                results.append(url)
                return true
            }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        // When
        urls.forEach { sut.action(url: $0) }
        
        // Then
        XCTAssertTrue(results == urls)
    }
    
    func test_that_deeplink_action_pass_path_parameters() {
        // Given
        let url = URL(string: "deeplinker://test")!
        let paths = ["a", "b", "c"]
        
        var results: [String] = []
        
        guard let sut = Deeplink(
            url: "deeplinker://test/:path",
            action: { _, parameters, _ in
                if let path = parameters["path"] {
                    results.append(path)
                }
                
                return true
            }
        ) else {
            XCTFail("Invalid url format.")
            return
        }
        
        // When
        paths.map { url.appendingPathComponent($0) }
            .forEach { sut.action(url: $0) }
        
        // Then
        XCTAssertTrue(results == paths)
    }
}
