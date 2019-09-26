//
//  Book.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import Vapor
extension Book: Content{}

extension Book: LosslessHTTPBodyRepresentable{
    func convertToHTTPBody() -> HTTPBody{
        return try! HTTPBody(data: JSONEncoder().encode(self))
    }
}
