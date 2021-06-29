//
//  Extension.swift
//  TraCkOVID
//
//  Created by Jervy Umandap on 6/29/21.
//

import Foundation

extension DateFormatter {
    static let dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()
    
    
    static let prettyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()
}
