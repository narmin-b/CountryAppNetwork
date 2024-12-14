//
//  CountryDetailViewController.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 12.12.24.
//

import UIKit
import MapKit

// TODO: detail func seperately, map into functions

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
        DispatchQueue.main.async {
            map.addAnnotation(self.viewModel.getLocationOnMap())
        }
        map.setCenter(viewModel.getCoordinates(), animated: true)
        
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
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CountryDetailCollectionCell.self, forCellWithReuseIdentifier: "CountryDetailCollectionCell")
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundThird
        view.anchorSize(.init(width: 0, height: 400))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.addSubview(scrollStack)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var scrollStack: UIStackView = {
        let scrollStack = UIStackView(arrangedSubviews: [mapView, flagImageView, infoCollectionView])
        scrollStack.axis = .vertical
        scrollStack.spacing = 12
        scrollStack.backgroundColor = .backgroundThird
        scrollStack.layer.cornerRadius = 48
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
        infoCollectionView.reloadData()
        infoCollectionView.layoutIfNeeded()
    }
    
    fileprivate func configureNavigationBar() {
        
        navigationController?.navigationBar.tintColor = .backgroundMain
        navigationController?.navigationBar.backgroundColor = .clear

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentHeight = infoCollectionView.contentSize.height
        infoCollectionView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
    }
    
    override func configureView() {
        configureNavigationBar()

        view.addSubViews(bgView, loadingView, scrollView)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        bgView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(all: 0)
        )
                
        loadingView.centerXToSuperview()
        loadingView.centerYToSuperview()
        
        scrollView.fillSuperviewSafeAreaLayoutGuide(padding: .zero)
        scrollStack.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor,
            padding: .init(all: 0)
        )
        scrollStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        mapView.anchor(
            top: scrollStack.topAnchor,
            leading: scrollStack.leadingAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(all: 0)
        )
        
        flagImageView.centerXToView(to: scrollStack)
        
        infoCollectionView.anchor(
            leading: scrollStack.leadingAnchor,
            bottom: scrollStack.bottomAnchor,
            trailing: scrollStack.trailingAnchor,
            padding: .init(top: 0, left: 60, bottom: 0, right: -60)
        )
        infoCollectionView.heightAnchor.constraint(equalToConstant: 400).isActive = true
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
}

extension CountryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfoList.allCases.count * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryDetailCollectionCell", for: indexPath) as? CountryDetailCollectionCell else {
            return UICollectionViewCell()
        }
        
        let field = InfoList.allCases[indexPath.item / 2]
        
        if(indexPath.item % 2 == 0) {
            cell.configureCell(title: field)
        } else {
            let title = viewModel.getTitleForCell(indexPath: indexPath)
            cell.configureCell(title: title)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (infoCollectionView.frame.width)/2, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 80, right: 0)
    }
}
