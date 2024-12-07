//
//  CoreErrorModel.swift
//  CountryAppNetwrok
//
//  Created by Narmin Baghirova on 07.12.24.
//

import Foundation
struct CoreErrorModel: Error, Decodable {
    let code: Int?
    let message: String?
    
    
    static func authError(code: Int) -> CoreErrorModel {
        return CoreErrorModel(code: code, message: "Zehmet olmasa yeniden login olun")
    }
    
    static func generalError() -> CoreErrorModel {
        return CoreErrorModel(code: 500, message: "Xeta bash verdi")
    }

    static func decodingError() -> CoreErrorModel {
        return CoreErrorModel(code: 0, message: "Can not parse json")
    }
}
