//
//  String+Verification.swift
//  Authorization
//
//  Created by Aleksandr Timakov on 18.05.2018.
//  Copyright © 2018 Aleksandr Timakov. All rights reserved.
//

import Foundation

extension String {
    private static let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
    private static let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
    private static let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,6}"
    private static let __password = "(?=^.{6,}$)^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).*$"
    public var isEmail: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__emailRegex)
        return predicate.evaluate(with: self)
    }
    public var isPassword: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type(of:self).__password)
        return predicate.evaluate(with: self)
    }
}
