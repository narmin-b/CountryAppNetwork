//
//  CountryDetailViewModel.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 12.12.24.
//

import Foundation
import MapKit

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
    
    func getCoordinates() -> CLLocationCoordinate2D {
        let lat = CLLocationDegrees(country.latlong.first ?? 0.0)
        let long = CLLocationDegrees(country.latlong.last ?? 0.0)

        let coordinates = CLLocationCoordinate2DMake(lat, long)
        listener?(.success)
        return coordinates
    }
    
    func getTitleForCell(indexPath: IndexPath) -> String {
        let field = InfoList.allCases[indexPath.row / 2]

        switch field {
        case .region:
            listener?(.success)
            return country.regionString
        case .area:
            listener?(.success)
            return String(country.areaDbl)
        case .capital:
            listener?(.success)
            return country.capitalString
        case .population:
            listener?(.success)
            return String(country.populationInt)
        case .currency:
            listener?(.success)
            return country.currencyString
        }
    }
    
    func getLocationOnMap() ->  MKPointAnnotation {
        let countryPin = MKPointAnnotation()
        countryPin.coordinate = getCoordinates()
        listener?(.success)
        return countryPin
    }
}
