//
//  CountryDetailViewModel.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 12.12.24.
//

import Foundation

final class CountryDetailViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var listener: ((ViewState) -> Void)?
    private var country: CountryDTO
    
    init(country: CountryDTO) {
        self.country = country
    }
    
    func getCountry() -> CountryDetailProtocol {
        return country
    }
}
