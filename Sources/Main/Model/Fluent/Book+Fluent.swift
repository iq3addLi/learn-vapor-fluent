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
    
    // Table name
    public static var name: String {
        return "Books"
    }
}

extension Book {
    // this book's related publisher
    var publisher: Parent<Book, Publisher>? {
        return parent(\.publisherId)
    }
}
