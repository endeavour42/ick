//
//  IckModel+first5th.swift
//  Ick
//
//  Created by endeavour42 on 11/05/2022.
//

import Foundation

// MARK: first 5th Character

extension IckModel {
    
    static let first5thCharJobTitle = StringKey.first5thChar.localized
    
    func first5thCharJob() -> StringJob {
        StringJobImpl {
            try await self.endpointUrl.loadString().string
        } process: { string in
            guard string.count >= 5 else { return "" }
            return String(string[4 ..< 5])
        } complete: { [weak self] string in
            self?.state.items[0].value = "'\(string)'"
        } failed: { [weak self] error in
            self?.state.items[0].value = error.localizedDescription
        }
    }
}
