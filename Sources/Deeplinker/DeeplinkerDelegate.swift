//
//  DeeplinkerDelegate.swift
//  
//
//  Created by JSilver on 2023/01/14.
//

import Foundation

public protocol DeeplinkerDelegate: AnyObject {
    /// Asks the delegate if the deeplinker should handle an deeplink with url.
    func deeplinker(
        _ deeplinker: Deeplinker,
        shouldHandle url: URL
    ) -> Bool
}

public extension DeeplinkerDelegate {
    func deeplinker(
        _ deeplinker: Deeplinker,
        shouldHandle url: URL
    ) -> Bool {
        true
    }
}
