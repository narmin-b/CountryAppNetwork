//
//  AllCountryAPIService.swift
//  CountryAppNetwrok
//
//  Created by Narmin Baghirova on 07.12.24.
//

import Foundation

final class AllCountryAPIService {
    static let instance = AllCountryAPIService()
    private init() {}
    
    func getAllCountry(completion: @escaping((CountryList?, CoreErrorModel?) -> Void)) {
        CoreAPIManager.instance.request(
            type: CountryList.self,
            url: AllCountryHelper.all.path,
            method: .GET) { [weak self] result in
                guard let _ = self else {return}
                switch result {
                    case .success(let list):
                        completion(list, nil)
                    case .failure(let error):
                        completion(nil, error)
                }
            }
    }
}
