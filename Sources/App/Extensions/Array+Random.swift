//
//  Array+Random.swift
//  VaporServer
//
//  Created by Nicholas Swift on 4/13/17.
//
//

import Foundation

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
