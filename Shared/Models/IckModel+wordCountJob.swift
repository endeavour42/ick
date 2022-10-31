//
//  IckModel+wordCountJob.swift
//  Ick
//
//  Created by endeavour42 on 11/05/2022.
//

import Foundation

// MARK: Word Counter

extension IckModel {
    
    static let wordCountJobTitle = StringKey.wordCounter.localized
    
    func wordCountJob() -> StringJob {
        StringJobImpl {
            try await self.endpointUrl.loadString().string
        } process: { string in
            string
                .split { char in
                    guard char.unicodeScalars.count == 1 else { return false }
                    guard let unichar = char.unicodeScalars.first else { return false }
                    return CharacterSet.whitespaces.contains(unichar)
                }
                .reduce([String: Int]()) { result, current in
                    var result = result
                    result[current.lowercased(), default: 0] += 1
                    return result
                }
                .sorted { $0.key < $1.key }     // secondary sort by name
                .sorted { $0.value > $1.value } // primary sort by count
                .map { "\($0.value): \($0.key)"}
                .joined(separator: "\n")
        } complete: { [weak self] string in
            self?.state.items[2].value = string
        } failed: { [weak self] error in
            self?.state.items[2].value = error.localizedDescription
        }
    }
}
