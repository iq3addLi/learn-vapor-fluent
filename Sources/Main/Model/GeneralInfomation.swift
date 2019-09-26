//
//  GeneralInfomation.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/20.
//

struct GeneralInfomation{
    let infomation: String
    
    init(_ infomation: String){
        self.infomation = infomation
    }
}

extension GeneralInfomation: Codable{}
