//
//  Publisher+Fluent.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/26.
//

import FluentMySQL

extension Publisher: MySQLModel{
    public var id: Int? {
        get {
            return identifier
        }
        set(newValue) {
            identifier = newValue
        }
    }
    
    // Table name
    public static var name: String {
        return "Publishers"
    }
}


extension Publisher {
    // this publisher's related books
    var books: Children<Publisher, Book> {
        return children(\.publisherId)
    }
}
