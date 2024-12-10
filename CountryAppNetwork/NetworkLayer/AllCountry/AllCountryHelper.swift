//
//  AllCountryHelper.swift
//  CountryAppNetwrok
//
//  Created by Narmin Baghirova on 07.12.24.
//

import Foundation

enum AllCountryHelper {
    case all
    
    var endpoint: String {
        switch self {
            case .all:
                ""
        }
    }
    
    var basePath: String {
        return "all/"
    }
    
    var path: URL? {
        switch self {
            case .all:
                return CoreAPIHelper.instance.makeURL(path: basePath + self.endpoint)
        }
    }
}
