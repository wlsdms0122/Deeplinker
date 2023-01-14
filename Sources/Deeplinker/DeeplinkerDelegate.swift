//
//  DeeplinkerDelegate.swift
//  
//
//  Created by JSilver on 2023/01/14.
//

import Foundation

public protocol DeeplinkerDelegate: AnyObject {
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
