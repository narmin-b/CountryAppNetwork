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
        case refreshed
        case success
        case error(message: String)
    }
    
    var listener: ((ViewState) -> Void)?
    private(set) var allCountryList: CountryList?
    private var searchList: CountryList?
    private var areaSortSmallToBig: Bool = true
    private var nameSortAToZ: Bool = true
    private var areaSortBigToSmall: Bool = false
    private var nameSortZToA: Bool = false
    
    fileprivate func reloadAllCountryList(state: ViewState) {
        AllCountryAPIService.instance.getAllCountry { [weak self] result, error in
            guard let self = self else {return}
            listener?(state)
            if let result = result {
                allCountryList = result
                searchList = allCountryList
                listener?(.success)
            } else if let error = error {
                listener?(.error(message: error.localizedDescription))
            }
        }
    }
    
    func getAllCountryList() {
        self.listener?(.loading)
        reloadAllCountryList(state: .loaded)
    }
    
    func refreshAllCountryList() {
        reloadAllCountryList(state: .refreshed)
    }
    
    func getItems() -> Int {        
        return searchList?.count ?? 0
    }
    
    func getCountry(index: Int) -> CountryDTO? {
        return searchList?[index]
    }
    
    func getProtocol(index: Int) -> TitleImageProtocol? {
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
    
    func sortAllCountryList() {
        searchList = allCountryList
        listener?(.success)
    }
    
    func sortListByArea(_ type: Int) {
        if type == 0 {
            searchList = allCountryList?.sorted(by: {$0.area ?? 0 < $1.area ?? 0})
        } else {
            searchList = allCountryList?.sorted(by: {$0.area ?? 0 > $1.area ?? 0})
        }
        listener?(.success)
    }
    
    func sortAreaToggle() {
        if areaSortSmallToBig {
            sortListByArea(0)
            areaSortSmallToBig.toggle()
            areaSortBigToSmall.toggle()
        } else if areaSortBigToSmall {
            sortListByArea(1)
            areaSortBigToSmall.toggle()
        } else {
            sortAllCountryList()
        }
    }
    
    func sortNameToggle() {
        if nameSortAToZ {
            sortListByName(0)
            nameSortZToA.toggle()
            nameSortAToZ.toggle()
        } else if nameSortZToA {
            sortListByName(1)
            nameSortZToA.toggle()
        } else {
            sortAllCountryList()
        }
    }
    
    func sortListByName(_ type: Int) {
        if type == 0 {
            searchList = allCountryList?.sorted(by: {$0.name?.official ?? "" < $1.name?.official ?? ""})
        } else {
            searchList = allCountryList?.sorted(by: {$0.name?.official ?? "" > $1.name?.official ?? ""})
        }
        listener?(.success)
    }
}
