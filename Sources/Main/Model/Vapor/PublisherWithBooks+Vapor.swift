//
//  PublisherWithBook+Vapor.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/26.
//

import Vapor

extension PublisherWithBooks: Content{}
extension PublisherWithBooks: LosslessHTTPBodyRepresentable{
    func convertToHTTPBody() -> HTTPBody{
        return try! HTTPBody(data: JSONEncoder().encode(self))
    }
}
