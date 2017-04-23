//
//  PasswordCredentials.swift
//  VaporServer
//
//  Created by Alex Aaron Peña on 4/19/17.
//
//

import Foundation
import Turnstile


/**
 PasswordCredentials represents a password.
 */
public class PasswordCredentials: Credentials {
    /// Username (set once user is created)
    public var username: String
    
    /// Password (unhashed)
    public let password: String
    
    /// Initializer for PasswordCredentials
    public init(password: String) {
        self.username = ""
        self.password = password
    }
}
