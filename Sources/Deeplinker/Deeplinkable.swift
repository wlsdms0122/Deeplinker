//
//  Deeplinkable.swift
//  
//
//  Created by JSilver on 2023/01/14.
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
    /// Store deeplink url to handle after.
    func store(url: URL)
}
