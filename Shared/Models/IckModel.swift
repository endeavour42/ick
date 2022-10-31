//
//  IckModel.swift
//  Ick
//
//  Created by endeavour42 on 11/05/2022.
//

import Foundation

struct ModelState {
    struct JobResult: Identifiable, Hashable {
        let id: Int
        let title: String
        var value: String
    }
    @MainActor var items: [JobResult] = [
        JobResult(id: 0, title: IckModel.first5thCharJobTitle, value: ""),
        JobResult(id: 1, title: IckModel.every10thCharJobTitle, value: ""),
        JobResult(id: 2, title: IckModel.wordCountJobTitle, value: "")
    ]
}

class IckModel: ObservableObject {
    @Published var state = ModelState()
    
    private (set) var endpointUrl = URL(string: "https://www.ietf.org/rfc/rfc793.txt")!
    
    func overrideUrl(_ url: URL) {
        endpointUrl = url
    }

    func query() {
        first5thCharJob().perform()
        every10thCharJob().perform()
        wordCountJob().perform()
    }
}

