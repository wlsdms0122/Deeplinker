//
//  Collection+Safe.swift
//  
//
//  Created by jsilver on 2022/10/15.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
