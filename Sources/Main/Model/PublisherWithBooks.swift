//
//  PublisherWithBooks.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/26.
//

import Foundation

struct PublisherWithBooks{
    let identifier: Int
    let name: String
    let books: [Book]?
}

extension PublisherWithBooks: Codable{}
