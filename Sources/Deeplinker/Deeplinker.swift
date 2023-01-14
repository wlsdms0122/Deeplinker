//
//  Deeplinker.swift
//
//
//  Created by jsilver on 2022/09/09.
//

import Foundation

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
    @discardableResult
    public func handle(url: URL) -> Bool {
        guard canHandle else {
            // Store url until to can handle.
            store(url: url)
            return false
        }
        
        // Reset deferred url.
        deferredURL = nil
        // Handle first matched deeplink with url.
        let deeplink = deeplinks.first { $0.matches(url: url) }
        
        return deeplink?.action(url: url)
            ?? defaultDeeplink?.action(url: url)
            ?? false
    }
    
    public func handle() -> Bool {
        canHandle = true
        
        guard let url = deferredURL else { return false }
        // Handle deferred url.
        return handle(url: url)
    }
    
    public func store(url: URL) {
        deferredURL = url
    }
    
    public func addDefault(action: @escaping Action) {
        self.defaultDeeplink = Deeplink(pattern: ".*", action: action)
    }
    
    public func addDeeplink(_ deeplink: Deeplink) {
        deeplinks.append(deeplink)
    }
    
    public func addURL(
        _ url: URL,
        action: @escaping Action
    ) {
        guard let deeplink = Deeplink(
            url: url,
            action: action
        ) else { return }
        
        addDeeplink(deeplink)
    }
    
    public func addURL(
        _ url: String,
        action: @escaping Action
    ) {
        guard let deeplink = Deeplink(
            url: url,
            action: action
        ) else { return }
        
        addDeeplink(deeplink)
    }
    
    // MARK: - Private
}
