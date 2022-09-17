//
//  Deeplink.swift
//  
//
//  Created by jsilver on 2022/09/17.
//

import Foundation

public typealias Parameters = [String: String]
public typealias Queries = [String: String]

struct PathParameter {
    let key: String
    let depth: Int
}

public struct Deeplink {
    // MARK: - Property
    private let url: URL
    private let action: (URL, Parameters, Queries) -> Void
    
    private let urlPattern: String
    private let parameters: [PathParameter]
    
    // MARK: - Initializer
    init?(
        url: URL,
        action: @escaping (URL, Parameters, Queries) -> Void
    ) {
        guard var urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ) else {
            return nil
        }
        
        // Remove all queries.
        urlComponents.queryItems = nil
        guard var urlString = urlComponents.string else { return nil }
        // Remove last '/' path character.
        if urlString.last == "/" {
            urlString.removeLast()
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        self.url = url
        self.action = action
        
        // Store path parameter if pattern exist in url.
        self.parameters = url.pathComponents
            .enumerated()
            .compactMap { offset, element -> (String, Int)? in
                let key = element.match(pattern: "(?<=:).*")
                    .compactMap { element[$0.range] }
                    .first
                guard let key else { return nil }
                
                return (key, offset)
            }
            .map { PathParameter(key: $0, depth: $1) }
        
        // Replace parameter to pattern in url.
        let replacedParameterURL = url.absoluteString
            .replace(
                pattern: ":[a-zA-Z0-9]+",
                with: "[a-zA-Z0-9]+"
            )
        
        // Add query pattern in url.
        self.urlPattern = replacedParameterURL + "/?(\\?.*)?"
    }
    
    init?(
        url: String,
        action: @escaping (URL, Parameters, Queries) -> Void
    ) {
        guard let url = URL(string: url) else { return nil }
        self.init(url: url, action: action)
    }
    
    // MARK: - Public
    /// Check url matches with deeplink pattern.
    public func matches(url: URL) -> Bool {
        url.absoluteString.matches(pattern: urlPattern)
    }
    
    /// Perform action about passed url.
    @discardableResult
    public func action(url: URL) -> Bool {
        guard matches(url: url) else { return false }
        
        guard let urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ) else {
            return false
        }
        
        // Get path parameters.
        let parameters = Dictionary(
            uniqueKeysWithValues: parameters
                .map { ($0.key, url.pathComponents[$0.depth]) }
        )
        
        // Get queries.
        let queries = Dictionary(
            uniqueKeysWithValues: (urlComponents.queryItems ?? [])
                .compactMap { query -> (String, String)? in
                    guard let value = query.value else { return nil }
                    return (query.name, value)
                }
        )
        
        action(url, parameters, queries)
        return true
    }
    
    // MARK: - Private
}
