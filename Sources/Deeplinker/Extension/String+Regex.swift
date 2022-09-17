//
//  String+Regex.swift
//  
//
//  Created by jsilver on 2022/09/09.
//

import Foundation

extension String {
    func match(
        pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = []
    ) -> [NSTextCheckingResult] {
        guard let range = nsRange(of: self), range.length > 0 else { return [] }
        
        guard let regex = try? NSRegularExpression(
            pattern: pattern,
            options: regexOptions
        ) else { return [] }
        
        return regex.matches(
            in: self,
            options: matchingOptions,
            range: range
        )
    }
    
    func matches(
        pattern: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = []
    ) -> Bool {
        guard let range = nsRange(of: self) else { return false }
        
        let match = match(
            pattern: pattern,
            regexOptions: regexOptions,
            matchingOptions: matchingOptions
        )
            .first { $0.range == range }
        
        return match != nil
    }
    
    func replace(
        pattern: String,
        with replacementString: String
    ) -> String {
        guard let range = nsRange(of: self),
              let regex = try? NSRegularExpression(pattern: pattern) else { return self }
        
        return regex.stringByReplacingMatches(
            in: self,
            range: range,
            withTemplate: replacementString
        )
    }
}
