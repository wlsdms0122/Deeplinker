//
//  Deeplinker.swift
//
//
//  Created by jsilver on 2022/09/09.
//

import Foundation

public protocol Deeplinkable {
    /// Handle deeplink url.
    @discardableResult
    func handle(url: URL) -> Bool
}

public protocol DeferredDeeplinkable: Deeplinkable {
    /// Handle deferred deeplink url.
    @discardableResult
    func handle() -> Bool
}

public class Deeplinker: DeferredDeeplinkable {
    // MARK: - Property
    private var deeplinks: [Deeplink] = []
    private var defaultDeeplink: Deeplink?
    
    private var canHandle: Bool
    private var deferredURL: URL?
    
    // MARK: - Initializer
    public init(canHandle: Bool = true) {
        self.canHandle = canHandle
    }
    
    // MARK: - Public
    public func handle() -> Bool {
        canHandle = true
        
        guard let url = deferredURL else { return false }
        deferredURL = nil
        
        // Handle deferred url.
        return handle(url: url)
    }
    
    @discardableResult
    public func handle(url: URL) -> Bool {
        guard canHandle else {
            // Store url until to can handle.
            deferredURL = url
            return false
        }
        
        // Handle first matched deeplink with url.
        let deeplink = deeplinks.first { $0.matches(url: url) }
        
        return deeplink?.action(url: url)
            ?? defaultDeeplink?.action(url: url)
            ?? false
    }
    
    public func addDefault(action: @escaping Action) {
        self.defaultDeeplink = Deeplink(pattern: ".*", action: action)
    }
    
    public func addDeeplink(_ deeplink: Deeplink) {
        deeplinks.append(deeplink)
    }
    
    public func addURL(
        _ url: String,
        action: @escaping (URL, Parameters, Queries) -> Void
    ) {
        guard let deeplink = Deeplink(
            url: url,
            action: action
        ) else {
            return
        }
        
        addDeeplink(deeplink)
    }
    
    // MARK: - Private
}
