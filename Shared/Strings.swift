//
//  Strings.swift
//  Ick
//
//  Created by endeavour42 on 31/10/2022.
//

import Foundation

enum StringKey: String {
    case query
    case appName
    case first5thChar
    case every10thChar
    case wordCounter
    
    var localized: String {
        NSLocalizedString(rawValue, comment: rawValue)
    }
}
