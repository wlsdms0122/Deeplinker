//
//  Deeplink.swift
//  
//
//  Created by jsilver on 2022/10/12.
//

import Foundation
import Testing
@testable import Deeplinker

@Suite("Deeplink Tests")
struct DeeplinkTests {
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    // MARK: - Test
    @Test(arguments: [
        "deeplinker://a/b",
        "deeplinker://a/b?",
        "deeplinker://a/b?c",
        "deeplinker://a/b?c=",
        "deeplinker://a/b?c=d",
        "deeplinker://a/b/",
        "deeplinker://a/b/?",
        "deeplinker://a/b/?c",
        "deeplinker://a/b/?c=",
        "deeplinker://a/b/?c=d"
    ])
    func initializeWithURL(url: String) {
        #expect(Deeplink(url: url) { _, _, _ in true } != nil)
    }
    
    @Test(arguments: [
        "a/b",                  // Missing scheme. (nil)
        "://a/b",               // Missing scheme. (empty)
        "deeplinker:///a",      // Missing host. (nil)
        "deeplinker://:1004/a", // Missing host. (empty),
        ""                      // Invalid url format.
    ])
    func initializeWithURLFail(url: String) {
        #expect(Deeplink(url: url) { _, _, _ in true } == nil)
    }
    
    @Test(arguments: [
        "https://www.apple.com",
        "http://www.google.com"
    ])
    func matchesPattern(url: String) throws {
        let sut = Deeplink(
            pattern: "(http|https)://.*",
            action: { _, _, _ in true }
        )
        
        try #expect(sut.matches(url: #require(URL(string: url))))
    }
    
    @Test(arguments: [
        "deeplinker://a/b",
        "deeplinker://a/b?",
        "deeplinker://a/b?c",
        "deeplinker://a/b?c=",
        "deeplinker://a/b?c=d",
        "deeplinker://a/b/",
        "deeplinker://a/b/?",
        "deeplinker://a/b/?c",
        "deeplinker://a/b/?c=",
        "deeplinker://a/b/?c=d"
    ])
    func matchesURL(url: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://a/b",
            action: { _, _, _ in true }
        ))
        
        try #expect(sut.matches(url: #require(URL(string: url))))
    }
    
    @Test(arguments: [
        "deeplinker://a/b",
        "deeplinker://a/b?",
        "deeplinker://a/b?c",
        "deeplinker://a/b?c=",
        "deeplinker://a/b?c=d",
        "deeplinker://a/b/",
        "deeplinker://a/b/?",
        "deeplinker://a/b/?c",
        "deeplinker://a/b/?c=",
        "deeplinker://a/b/?c=d"
    ])
    func matchesURLWithEndSlash(url: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://a/b/",
            action: { _, _, _ in true }
        ))
        
        try #expect(sut.matches(url: #require(URL(string: url))))
    }
    
    @Test(arguments: [
        "deeplinker://a/b",
        "deeplinker://a/b?",
        "deeplinker://a/b?c",
        "deeplinker://a/b?c=",
        "deeplinker://a/b?c=d",
        "deeplinker://a/b/",
        "deeplinker://a/b/?",
        "deeplinker://a/b/?c",
        "deeplinker://a/b/?c=",
        "deeplinker://a/b/?c=d"
    ])
    func matchesURLWithQuery(url: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://a/b?key=value",
            action: { _, _, _ in true }
        ))
        
        try #expect(sut.matches(url: #require(URL(string: url))))
    }
    
    @Test(arguments: [
        "deeplinker://a/b",
        "deeplinker://a/b?",
        "deeplinker://a/b?c",
        "deeplinker://a/b?c=",
        "deeplinker://a/b?c=d",
        "deeplinker://a/b/",
        "deeplinker://a/b/?",
        "deeplinker://a/b/?c",
        "deeplinker://a/b/?c=",
        "deeplinker://a/b/?c=d"
    ])
    func matchesURLWithEndSlashAndQuery(url: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://a/b/?key=value",
            action: { _, _, _ in true }
        ))
        
        try #expect(sut.matches(url: #require(URL(string: url))))
    }
    
    @Test(arguments: [
        "scheme://a/b",
        "deeplinker://a",
        "deeplinker://a/",
        "deeplinker://a/c",
        "deeplinker://a/c/",
        "deeplinker://a/b/c",
        "deeplinker://a/b/c/"
    ])
    func mismatchesURL(url: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://a/b",
            action: { _, _, _ in true }
        ))
        
        try #expect(!sut.matches(url: #require(URL(string: url))))
    }
    
    @Test(arguments: [
        "deeplinker://a/b",
        "deeplinker://a/b?",
        "deeplinker://a/b?c",
        "deeplinker://a/b?c=",
        "deeplinker://a/b?c=d",
        "deeplinker://a/b/",
        "deeplinker://a/b/?",
        "deeplinker://a/b/?c",
        "deeplinker://a/b/?c=",
        "deeplinker://a/b/?c=d",
        "deeplinker://a/c?",
        "deeplinker://a/c?d",
        "deeplinker://a/c?e=",
        "deeplinker://a/c?e=f",
        "deeplinker://a/c/",
        "deeplinker://a/c/?",
        "deeplinker://a/c/?e",
        "deeplinker://a/c/?e=",
        "deeplinker://a/c/?e=f"
    ])
    func matchesURLWithPathParameter(url: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://a/:path",
            action: { _, _, _ in true }
        ))
        
        try #expect(sut.matches(url: #require(URL(string: url))))
    }
    
    @Test(arguments: [
        "scheme://a/b",
        "deeplinker://a",
        "deeplinker://a/",
        "deeplinker://a/b/c",
        "deeplinker://a/b/c/"
    ])
    func mismatchesURLWithPathParameter(url: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://a/:path",
            action: { _, _, _ in true }
        ))
        
        try #expect(!sut.matches(url: #require(URL(string: url))))
    }
    
    @Test(arguments: [
        "deeplinker://a/b",
        "deeplinker://a/b?",
        "deeplinker://a/b?c",
        "deeplinker://a/b?c=",
        "deeplinker://a/b?c=d",
        "deeplinker://a/b/",
        "deeplinker://a/b/?",
        "deeplinker://a/b/?c",
        "deeplinker://a/b/?c=",
        "deeplinker://a/b/?c=d"
    ])
    func actionURL(matches url: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://a/b",
            action: { _, _, _ in false }
        ))
        
        try #expect(!sut.action(url: #require(URL(string: url))))
    }
    
    @Test(arguments: [
        "scheme://a/b",
        "deeplinker://a",
        "deeplinker://a/",
        "deeplinker://a/c",
        "deeplinker://a/c/",
        "deeplinker://a/b/c",
        "deeplinker://a/b/c/"
    ])
    func actionURL(mismatches url: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://a/b",
            action: { _, _, _ in true }
        ))
        
        try #expect(!sut.action(url: #require(URL(string: url))))
    }
    
    @Test(arguments: zip([
        "deeplinker://test/a",
        "deeplinker://test/b",
        "deeplinker://test/c"
    ], [
        "a",
        "b",
        "c"
    ]))
    func actionURLHandlePathParameter(url: String, result: String) throws {
        let sut = try #require(Deeplink(
            url: "deeplinker://test/:path",
            action: { _, parameters, _ in
                #expect(parameters["path"] == result)
                return true
            }
        ))
        
        try sut.action(url: #require(URL(string: url)))
    }
}
