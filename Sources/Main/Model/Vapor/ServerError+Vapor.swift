//
//  ServerError.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/20.
//

import Vapor

extension ServerError: Content{}

// Requires implementation when generating Response
extension ServerError: LosslessHTTPBodyRepresentable{
    func convertToHTTPBody() -> HTTPBody{
        return try! HTTPBody(data: JSONEncoder().encode(self))
    }
}
