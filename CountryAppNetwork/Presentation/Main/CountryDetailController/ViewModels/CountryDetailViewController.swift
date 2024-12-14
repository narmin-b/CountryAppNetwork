//
//  CountryDetailViewController.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 12.12.24.
//

import UIKit
import MapKit

enum InfoList: String, CaseIterable {
    case region, area, capital, population, currency
}

class CountryDetailViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        map.anchorSize(.init(width: 0, height: 300))
        map.translatesAutoresizingMaskIntoConstraints = false
        map.addAnnotation(getLocationOnMap())
        map.centerCoordinate = getLocationOnMap().coordinate
        return map
    }()
    
    private lazy var flagImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.anchorSize(.init(width: 0, height: 160))
        let country = viewModel.getCountry()
        view.loadImageURL(url: country.flagString)
        return view
    }()
    
    private lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CountryDetailCollectionCell.self, forCellWithReuseIdentifier: "CountryDetailCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.anchorSize(.init(width: 180, height: 0))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var DetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CountryDetailCollectionCell.self, forCellWithReuseIdentifier: "CountryDetailCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.anchorSize(.init(width: 180, height: 0))

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var collectionStack: UIStackView = {
        let scrollStack = UIStackView(arrangedSubviews: [infoCollectionView, DetailCollectionView])
        scrollStack.axis = .horizontal
        scrollStack.spacing = 8
        scrollStack.translatesAutoresizingMaskIntoConstraints = false
        return scrollStack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.addSubview(scrollStack)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var scrollStack: UIStackView = {
        let scrollStack = UIStackView(arrangedSubviews: [mapView, flagImageView, infoCollectionView])
        scrollStack.axis = .vertical
        scrollStack.spacing = 12
        scrollStack.translatesAutoresizingMaskIntoConstraints = false
        return scrollStack
    }()
    
    private var viewModel: CountryDetailViewModel
    private var coordinates: CLLocationCoordinate2D?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: CountryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    override func configureView() {
        view.addSubViews(loadingView, mapView, flagImageView, collectionStack) //infoCollectionView)
//        view.addSubview(scrollView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.centerXToSuperview()
        loadingView.centerYToSuperview()
        
//        scrollView.fillSuperviewSafeAreaLayoutGuide(padding: .zero)
//
        mapView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        flagImageView.anchor(
            top: mapView.bottomAnchor,
            padding: .init(top: 12, left: 0, bottom: 0, right: 0)
        )
        flagImageView.centerXToSuperview()
        
        collectionStack.anchor(
            top: flagImageView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 12, left: 16, bottom: 0, right: -16)
        )
        
//        infoCollectionView.anchor(
//            top: flagImageView.bottomAnchor,
//            leading: view.leadingAnchor,
//            bottom: view.safeAreaLayoutGuide.bottomAnchor,
//            trailing: view.trailingAnchor,
//            padding: .init(top: 12, left: 16, bottom: 0, right: -16)
//        )
    }
    
    fileprivate func configureViewModel() {
        viewModel.listener = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.loadingView.startAnimating()
            case .loaded:
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                }
            case .success:
                DispatchQueue.main.async {
                    self.infoCollectionView.reloadData()
                }
            case .error(let message):
                self.showMessage(title: message)
            }
        }
    }
    
    fileprivate func getTitleForCell(indexPath: IndexPath) -> String {
        let field = InfoList.allCases[indexPath.row]
        let country = viewModel.getCountry()
        switch field {
        case .region:
            return country.regionString
        case .area:
            return String(country.areaDbl)
        case .capital:
            return country.capitalString
        case .population:
            return String(country.populationInt)
        case .currency:
            return country.currencyString
        }
    }
    
    fileprivate func getLocationOnMap() ->  MKPointAnnotation {
        coordinates = viewModel.getCoordinates()
        let countryPin = MKPointAnnotation()
        countryPin.title = "Capital"
        countryPin.coordinate = coordinates ?? CLLocationCoordinate2D()
        return countryPin
    }
}

extension CountryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfoList.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryDetailCollectionCell", for: indexPath) as? CountryDetailCollectionCell else {
            return UICollectionViewCell()
        }
        let field = InfoList.allCases[indexPath.row]
        
        if collectionView == infoCollectionView {
            cell.configureCell(title: field)
        } else {
            let title = getTitleForCell(indexPath: indexPath)
            cell.configureCell(title: title)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 144, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
}
