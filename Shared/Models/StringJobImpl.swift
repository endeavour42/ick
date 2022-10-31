//
//  StringJobImpl.swift
//  Ick
//
//  Created by endeavour42 on 11/05/2022.
//

import Foundation

struct StringJobImpl: StringJob {
    let load: () async throws -> String
    let process: (String) -> String
    let complete: @MainActor (String) -> Void
    let failed: @MainActor (Error) -> Void
    
    func perform() {
        Task {
            await performAsync()
        }
    }
    
    func performAsync() async {
        do {
            let rawString = try await load()
            let string = process(rawString)
            await MainActor.run {
                complete(string)
            }
        } catch {
            await MainActor.run {
                failed(error)
            }
        }
    }
}
