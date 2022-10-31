//
//  IckModel+every10thCharJob.swift
//  Ick
//
//  Created by endeavour42 on 11/05/2022.
//

import Foundation

// MARK: Every 10th Character

extension IckModel {
    
    static let every10thCharJobTitle = StringKey.every10thChar.localized
    
    func every10thCharJob() -> StringJob {
        StringJobImpl {
            try await self.endpointUrl.loadString().string
        } process: { string in
            let characters = string.enumerated().filter { index, char in
                ((index + 1) % 10) == 0
            }.map { $1 }
            return String(characters)
        } complete: { [weak self] string in
            self?.state.items[1].value = string
        } failed: { [weak self] error in
            self?.state.items[1].value = error.localizedDescription
        }
    }
}
