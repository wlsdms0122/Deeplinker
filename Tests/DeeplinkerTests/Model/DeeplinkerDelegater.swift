//
//  DeeplinkerDelegater.swift
//  
//
//  Created by JSilver on 2023/01/14.
//

import Foundation
import Deeplinker

class DeeplinkerDefaultDelegater: DeeplinkerDelegate { }

class DeeplinkerDelegater: DeeplinkerDelegate {
    // MARK: - Property
    private let shouldHandle: (URL) -> Bool
    
    // MARK: - Initializer
    init(shouldHandle: @escaping (URL) -> Bool) {
        self.shouldHandle = shouldHandle
    }
    
    // MARK: - Lifecycle
    func deeplinker(
        _ deeplinker: Deeplinker,
        shouldHandle url: URL
    ) -> Bool {
        shouldHandle(url)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
