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
    private lazy var refreshController: UIRefreshControl = {
        let controller = UIRefreshControl()
        controller.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        controller.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
   
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
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private lazy var flagImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.addSubview(scrollStack)
        scrollView.refreshControl = refreshController
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentHeight = infoCollectionView.contentSize.height
        infoCollectionView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
        
        mapView.anchorSize(.init(width: 0, height: view.safeAreaLayoutGuide.layoutFrame.height/3))
        
        flagImageView.anchorSize(.init(width: 0, height: view.safeAreaLayoutGuide.layoutFrame.height/4))

        bgView.anchorSize(.init(width: 0, height: view.safeAreaLayoutGuide.layoutFrame.height/3*2))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        infoCollectionView.reloadData()
        infoCollectionView.layoutIfNeeded()
    }
    
    fileprivate func loadFlagImage() {
        let country = viewModel.getCountry()
        flagImageView.loadImageURL(url: country.flagString)
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .backgroundMain
        navigationController?.navigationBar.backgroundColor = .clear

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func configureView() {
        configureNavigationBar()
        configureMapView()
        loadFlagImage()
        
        view.backgroundColor = .backgroundMain
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
                    self.refreshController.endRefreshing()
                }
            case .error(let message):
                self.showMessage(title: message)
            }
        }
    }
    
    fileprivate func configureMapView() {
        setRegion()
        addPin()
    }
    
    fileprivate func addPin() {
        DispatchQueue.main.async {
            self.mapView.addAnnotation(self.viewModel.getLocationOnMap())
        }
    }
    
    fileprivate func setRegion() {
        let coordinates = viewModel.getCoordinates()
        let span: MKCoordinateSpan = MKCoordinateSpan(
            latitudeDelta: 0.5, longitudeDelta: 0.5)
        mapView.setRegion(.init(center: coordinates, span: span), animated: true)
    }
    
    @objc fileprivate func refreshPage() {
        setRegion()
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

