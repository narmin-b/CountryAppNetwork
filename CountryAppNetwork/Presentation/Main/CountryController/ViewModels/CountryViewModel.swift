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
    private var searchList: CountryList?
    
    func getAllCountryList() {
        self.listener?(.loading)
        AllCountryAPIService.instance.getAllCountry { [weak self] result, error in
            guard let self = self else {return}
            listener?(.loaded)
            if let result = result {
                allCountryList = result
                searchList = allCountryList
                listener?(.success)
            } else if let error = error {
                listener?(.error(message: error.localizedDescription))
            }
        }
    }
    
    func getItems() -> Int {        
//        return allCountryList?.count ?? 0
        return searchList?.count ?? 0

    }
    
    func getProtocol(index: Int) -> TitleImageProtocol? {
//        return allCountryList?[index]
        return searchList?[index]
    }
    
    func searchCountry(_ searchText: String) {
        if searchText.isEmpty {
            searchList = allCountryList
            listener?(.success)
        } else {
            searchList = allCountryList?.filter({ $0.name?.official?.lowercased().contains(searchText.lowercased()) ?? false })
            listener?(.success)
        }
    }
    
    func sortListByArea() {
        searchList = allCountryList?.sorted(by: {$0.area ?? 0 < $1.area ?? 0})
        listener?(.success)
    }
    
    func sortListByName() {
        searchList = allCountryList?.sorted(by: {$0.name?.official ?? "" < $1.name?.official ?? ""})
        listener?(.success)
    }
}
