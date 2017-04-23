//
//  Date+HSFFormatting.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/22/17.
//
//

import Foundation

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
