//
//  Publisher+Vapor.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/26.
//

import Vapor
extension Publisher: Content{}

extension Publisher: LosslessHTTPBodyRepresentable{
    public func convertToHTTPBody() -> HTTPBody{
        return try! HTTPBody(data: JSONEncoder().encode(self))
    }
}

extension Array: LosslessHTTPBodyRepresentable where Element == Publisher{
    public func convertToHTTPBody() -> HTTPBody {
        return try! HTTPBody(data: JSONEncoder().encode(self))
    }
}
