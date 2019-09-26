//
//  ServerError.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/20.
//

import Foundation

struct ServerError{
    let reason: String
}

extension ServerError: Codable{}
