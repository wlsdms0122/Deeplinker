//
//  Deeplink.swift
//  
//
//  Created by jsilver on 2022/09/17.
//

import Foundation

public typealias Parameter = [String: String]
public typealias Query = [String: String]
public typealias Action = (URL, Parameter, Query) -> Bool

struct PathParameter {
    let key: String
    let depth: Int
}

public struct Deeplink {
    // MARK: - Property
    private let action: Action
    
    private let pattern: String
    private let parameters: [PathParameter]
    
    // MARK: - Initializer
    init?(
        url: URL,
        action: @escaping Action
    ) {
        var urlString = url.absoluteString
        
        if let query = url.query {
            // Remove all queries if exist.
            urlString = urlString.replace(pattern: "\\?\(query)", with: "")
        }
        
        if urlString.last == "/" {
            // Remove last '/' path character.
            urlString.removeLast()
        }
        
        guard let url = URL(string: urlString)
        else { return nil }
        
        guard !(url.scheme?.isEmpty ?? true)
              && !(url.host?.isEmpty ?? true)
        else {
            // Check url required format.
            return nil
        }
        
        self.action = action
        
        // Store path parameter if pattern exist in url.
        self.parameters = url.pathComponents
            .enumerated()
            .compactMap { offset, element -> (String, Int)? in
                let key = element.match(pattern: "(?<=:).*")
                    .compactMap { element[$0.range] }
                    .first
                guard let key
                else { return nil }
                
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
        self.pattern = replacedParameterURL + "/?(\\?.*)?"
    }
    
    init?(
        url: String,
        action: @escaping Action
    ) {
        guard let url = URL(string: url)
        else { return nil }
        
        self.init(url: url, action: action)
    }
    
    // MARK: - Public
    /// Check url matches with deeplink pattern.
    public func matches(url: URL) -> Bool {
        url.absoluteString.matches(pattern: pattern)
    }
    
    /// Perform action about passed url.
    @discardableResult
    public func action(url: URL) -> Bool {
        guard matches(url: url)
        else { return false }
        
        // Get path parameters.
        let parameters = Parameter(
            uniqueKeysWithValues: parameters
                .map { ($0.key, url.pathComponents[$0.depth]) }
        )
        
        // Get queries.
        let queryComponents = url.query?.split(separator: "&")
            .map { queryItem -> (key: String?, value: String?) in
                let query = queryItem.split(separator: "=")
                    .map { String($0) }
                return (query[safe: 0], query[safe: 1])
            } ?? []
        
        let queries = Query(
            uniqueKeysWithValues: queryComponents
                .compactMap { query -> (String, String)? in
                    guard let key = query.key,
                          let value = query.value
                    else { return nil }
                    
                    return (key, value)
                }
        )
        
        return action(url, parameters, queries)
    }
    
    // MARK: - Private
}
