//
//  String+Range.swift
//  
//
//  Created by jsilver on 2022/09/09.
//

import Foundation

extension String {
    func nsRange(of string: String) -> NSRange? {
        guard let range = range(of: string) else { return nil }
        return NSRange(range, in: self)
    }
    
    subscript(range: NSRange) -> String? {
        guard let range = Range(range, in: self) else { return nil }
        return String(self[range])
    }
}
