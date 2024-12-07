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
}
