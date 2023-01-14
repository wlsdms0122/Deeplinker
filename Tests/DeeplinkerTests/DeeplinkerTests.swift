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
    func test_that_deeplinker_that_added_as_deeplink_should_handle_when_url_matches_pattern() {
        // Given
        let sut = Deeplinker()
        sut.addDeeplink(Deeplink(url: "deeplinker://a/b") { _, _, _ in true }!)
        
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
        
        urls.forEach {
            // When
            let result = sut.handle(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was not handled."
            )
        }
    }
    
    func test_that_deeplinker_that_added_as_url_should_handle_when_url_matches_pattern() {
        // Given
        let sut = Deeplinker()
        sut.addURL(URL(string: "deeplinker://a/b")!) { _, _, _ in true }
        
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
        
        urls.forEach {
            // When
            let result = sut.handle(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was not handled."
            )
        }
    }
    
    func test_that_deeplinker_that_added_as_url_string_should_handle_when_url_matches_pattern() {
        // Given
        let sut = Deeplinker()
        sut.addURL("deeplinker://a/b") { _, _, _ in true }
        
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
        
        urls.forEach {
            // When
            let result = sut.handle(url: $0)
            
            // Then
            XCTAssertTrue(
                result,
                "\($0.absoluteString) was not handled."
            )
        }
    }
    
    func test_that_deeplinker_should_not_add_deeplink_when_add_invalid_deeplink() {
        // Given
        let sut = Deeplinker()
        
        let urlString = "a"
        let url = URL(string: urlString)!
        
        // When
        sut.addURL(url) { _, _, _ in true }
        sut.addURL(urlString) { _, _, _ in true }
        
        let result = sut.handle(url: url)
        
        // Then
        XCTAssertFalse(
            result,
            "\(url.absoluteString) was handled."
        )
    }
    
    func test_that_deeplinker_should_handle_mismatched_url_when_default_deeplink_is_added() {
        // Given
        let sut = Deeplinker()
        let url = URL(string: "deeplinker://a/b")!
        
        sut.addDefault { _, _, _ in true }
        
        // When
        let result = sut.handle(url: url)
        
        // Then
        XCTAssertTrue(
            result,
            "\(url.absoluteString) was not handled."
        )
    }
    
    func test_that_deeplinker_should_not_handle_when_deeplink_was_deferred() {
        // Given
        let sut = Deeplinker(canHandle: false)
        sut.addURL("deeplinker://a/b") { _, _, _ in true }
        
        let url = URL(string: "deeplinker://a/b")!
        
        // When
        let result = sut.handle(url: url)
        
        // Then
        XCTAssertFalse(
            result,
            "Deferred \(url.absoluteString) was handled."
        )
    }
    
    func test_that_deeplinker_should_handle_deferred_deeplink() {
        // Given
        let sut = Deeplinker(canHandle: false)
        sut.addURL("deeplinker://a/b") { _, _, _ in true }
        
        let url = URL(string: "deeplinker://a/b")!
        
        let isHandled = sut.handle(url: url)
        
        // When
        let result = sut.handle()
        
        // Then
        XCTAssertFalse(
            isHandled,
            "Deferred \(url.absoluteString) was handled."
        )
        XCTAssertTrue(
            result,
            "Deferred \(url.absoluteString) was not handled."
        )
    }
    
    func test_that_deeplinker_reset_deferred_deeplink_after_handle() {
        // Given
        let sut = Deeplinker(canHandle: false)
        sut.addURL("deeplinker://a/b") { _, _, _ in true }
        
        let url = URL(string: "deeplinker://a/b")!
        
        let isHandled = sut.handle(url: url)
        let isDeferredHandled = sut.handle()
        
        // When
        let result = sut.handle()
        
        // Then
        XCTAssertFalse(
            isHandled,
            "Deferred \(url.absoluteString) was handled."
        )
        XCTAssertTrue(
            isDeferredHandled,
            "Deferred \(url.absoluteString) was not handled."
        )
        XCTAssertFalse(
            result,
            "Deferred \(url.absoluteString) was not reset."
        )
    }
    
    func test_that_deeplinker_should_handle_stored_deeplink() {
        // Given
        let sut = Deeplinker()
        sut.addURL("deeplinker://a/b") { _, _, _ in true }
        
        let url = URL(string: "deeplinker://a/b")!
        
        // When
        sut.store(url: url)
        let result = sut.handle()
        
        // Then
        XCTAssertTrue(
            result,
            "Deferred \(url.absoluteString) was not handled."
        )
    }
    
    func test_that_deeplinker_should_reset_stored_deeplink_after_handle_new_deeplink() {
        // Given
        let sut = Deeplinker()
        sut.addURL("deeplinker://a/b") { _, _, _ in true }
        
        let storeURL = URL(string: "deeplinker://a/b")!
        let newURL = URL(string: "deeplinker://a/c")!
        
        // When
        // Store first deeplink.
        sut.store(url: storeURL)
        // Handle new deeplink.
        sut.handle(url: newURL)
        // Try to handle stored deeplink.
        let result = sut.handle()
        
        // Then
        XCTAssertFalse(
            result,
            "Deferred \(storeURL.absoluteString) was not reset."
        )
    }
    
    func test_that_deeplinker_should_handle_deeplink_when_set_delegate_with_default_implementation() {
        // Given
        let sut = Deeplinker()
        sut.addURL("deeplinker://a/b") { _, _, _ in true }
        
        let delegater = DeeplinkerDefaultDelegater()
        sut.delegate = delegater
        
        let url = URL(string: "deeplinker://a/b")!
        
        // When
        let result = sut.handle(url: url)
        
        // Then
        XCTAssertTrue(
            result,
            "\(url.absoluteString) was not handled."
        )
    }
    
    func test_that_deeplinker_should_not_handle_deeplink_when_delegate_should_handle_return_false() {
        // Given
        let sut = Deeplinker()
        sut.addURL("deeplinker://a/b") { _, _, _ in true }
        
        let delegater = DeeplinkerDelegater { _ in
            false
        }
        
        sut.delegate = delegater
        
        let url = URL(string: "deeplinker://a/b")!
        
        // When
        let result = sut.handle(url: url)
        
        // Then
        XCTAssertFalse(
            result,
            "\(url.absoluteString) was handled."
        )
    }
}
