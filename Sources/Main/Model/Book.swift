//
//  Book.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import Foundation

final class Book{
    var identifier: Int?
    var title: String
    var author: String
    
    init( identifier: Int?, title: String, author: String){
        self.identifier = identifier
        self.title = title
        self.author = author
    }
}

extension Book: Codable{}
