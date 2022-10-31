//
//  StringJob.swift
//  Ick
//
//  Created by endeavour42 on 11/05/2022.
//

import Foundation

protocol StringJob {
    var load: () async throws -> String { get }
    var process: (String) -> String { get }
    var complete: @MainActor (String) -> Void { get }
    var failed: @MainActor (Error) -> Void { get }
    
    func perform()
    func performAsync() async
}

