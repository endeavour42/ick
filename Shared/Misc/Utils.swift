//
//  Utils.swift
//  Ick
//
//  Created by endeavour42 on 11/05/2022.
//

import Foundation

extension URLSession {
    func string(from url: URL, delegate: URLSessionTaskDelegate? = nil) async throws -> (String, URLResponse) {
        let (data, response) = try await data(from: url, delegate: delegate)
        // TODO: figure from response's "Content-Type" header if present
        let encoding: String.Encoding = .utf8
        guard let string = String(data: data, encoding: encoding) ?? String(data: data, encoding: .ascii) else {
            throw NSError(domain: "", code: -1, userInfo: nil)
        }
        return (string, response)
    }
}

extension URL {
    func loadString() async throws -> (string: String, response: URLResponse) {
        try await URLSession.shared.string(from: self)
    }
}

extension String {
    subscript(range: Range<Int>) -> Substring {
        self[index(startIndex, offsetBy: range.lowerBound) ..< index(startIndex, offsetBy: range.upperBound)]
   }
}
