//
//  MainViewModel.swift
//  CountryAppNetwrok
//
//  Created by Narmin Baghirova on 04.12.24.
//

import Foundation

final class MainViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var listener: ((ViewState) -> Void)?
    private(set) var allCountryList: CountryList?
    
    func getAllCountryList() {
        self.listener?(.loading)
        AllCountryAPIService.instance.getAllCountry { [weak self] result, error in
            guard let self = self else {return}
            listener?(.loaded)
            if let result = result {
                print(result)
                allCountryList = result
                listener?(.success)
            } else if let error = error {
                listener?(.error(message: error.localizedDescription))
            }
        }
    }
    
    func getItems() -> Int {        
        return allCountryList?.count ?? 0
    }
    
    func getProtocol(index: Int) -> TitleImageProtocol? {
        return allCountryList?[index]
    }
}
