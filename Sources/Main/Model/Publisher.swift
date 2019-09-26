//
//  Publisher.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/26.
//

import Foundation

public final class Publisher{
    var identifier: Int?
    var name: String
    
    init(name: String, identifier: Int? = nil){
        self.name = name
        self.identifier = identifier
    }
}

extension Publisher: Codable{}
