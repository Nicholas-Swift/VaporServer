//
//  Date+StringFormatting.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/22/17.
//
//

import Foundation

//class HSFDatabaseDateFormatter {
//    
//    func hsfDateToString(date: Date) -> String {
//        
//        // Init date formatter
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
//        
//        // String date
//        let stringDate = dateFormatter.string(from: date)
//        
//        // Return
//        return stringDate
//    }
//    
//    func hsfStringToDate(string: String) throws -> Date {
//        
//        // Init date formatter
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
//        
//        // Back to date
//        guard let dateString = dateFormatter.date(from: string) else {
//            throw DateFormatError()
//        }
//        
//        // Return
//        return dateString
//    }
//    
//}

extension Date {
    
    func hsfToString() -> String {
        
        // Init date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        
        // String date
        let stringDate = dateFormatter.string(from: self)
        
        // Return
        return stringDate
    }
    
}

extension String {
    
    func hsfToDate() -> Date? {
        
        // Init date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        
        // Back to date
        let dateString = dateFormatter.date(from: self)
        
        // Return
        return dateString
    }
    
}

public protocol NickError: Error, CustomStringConvertible { }

public protocol DateError: NickError { }

public struct DateFormatError: DateError {
    public init() {}
    
    public let description = "Invalid date string format"
}
