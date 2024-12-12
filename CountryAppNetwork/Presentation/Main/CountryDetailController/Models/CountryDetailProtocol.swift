//
//  CountryDetailProtocol.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 12.12.24.
//

import Foundation

protocol CountryDetailProtocol {
    var flagString: String {get}
    var areaDbl: Double {get}
    var regionString: String {get}
    var capitalString: String {get}
    var populationInt: Int {get}
    var currencyString: String {get}
    var latlong: [Double] {get}
}
