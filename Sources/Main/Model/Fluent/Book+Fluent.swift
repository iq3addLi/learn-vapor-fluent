//
//  Book.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import FluentMySQL

extension Book: MySQLModel{
    var id: Int? {
        get {
            return identifier
        }
        set(newValue) {
            identifier = newValue
        }
    }
    
    public static var name: String {
        return "Books"
    }
//    static let sqlTableIdentifierString = "Books"
//    public static var sqlTableIdentifierString: String {
//        return "\(self.self)s"
//    }
}
