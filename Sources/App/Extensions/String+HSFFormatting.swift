//
//  String+HSFFormatting.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/22/17.
//
//

import Foundation

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
