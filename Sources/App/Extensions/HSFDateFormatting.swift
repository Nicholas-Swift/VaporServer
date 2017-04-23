//
//  HSFDateFormatting.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/22/17.
//
//

import Foundation

class HSFDateFormatting {
    
    static func hsfDateToString(date: Date) -> String {

        // Init date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")

        // String date
        let stringDate = dateFormatter.string(from: date)

        // Return
        return stringDate
    }

    static func hsfStringToDate(string: String) -> Date? {

        // Init date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")

        // Back to date
        let dateString = dateFormatter.date(from: string)
        
        // Return
        return dateString
    }
    
}
