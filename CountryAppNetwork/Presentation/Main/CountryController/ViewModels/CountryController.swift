//
//  MainViewController.swift
//  CountryAppNetwrok
//
//  Created by Narmin Baghirova on 04.12.24.
//

import UIKit

class MainViewController: BaseViewController {
    private lazy var refreshController: UIRefreshControl = {
        let controller = UIRefreshControl()
        controller.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        controller.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var countryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CountryTableViewCell.self, forCellWithReuseIdentifier: "CountryTableViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshController
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchTextfield: UITextField = {
        let textfield = ReusableTextField(placeholder: "Search", iconName: "magnifyingglass", iconSetting: 10)
        textfield.anchorSize(.init(width: 0, height: 48))
        textfield.delegate = self
        return textfield
    }()
    
    private lazy var sortByNameButton: UIButton = {
        let button = ReusableButton(title: "Sort By Name", onAction: sortNameButtonClicked)
        button.anchorSize(.init(width: 0, height: 32))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var sortByAreaButton: UIButton = {
        let button = ReusableButton(title: "Sort By Area", onAction: sortAreaButtonClicked)
        button.anchorSize(.init(width: 0, height: 32))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var sortingStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sortByNameButton, sortByAreaButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var searchFieldStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [searchTextfield, sortingStackView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var viewModel: MainViewModel
    private var list: CountryList?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: MainViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        viewModel.getAllCountryList()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
    }
    

    override func configureView() {
        configureNavigationBar()
        
        view.backgroundColor = .white
        
        view.addSubViews(loadingView, countryCollectionView, searchFieldStack)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureTargets() {
        
    }
    
    override func configureConstraint() {
        loadingView.centerXToSuperview()
        loadingView.centerYToSuperview()
        searchFieldStack.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 24, bottom: 0, right: -24)
        )
        searchTextfield.anchor(
            leading: searchFieldStack.leadingAnchor,
            trailing: searchFieldStack.trailingAnchor
        )
        sortingStackView.anchor(
            leading: searchFieldStack.leadingAnchor,
            bottom: searchFieldStack.bottomAnchor,
            trailing: searchFieldStack.trailingAnchor
        )
        countryCollectionView.anchor(
            top: searchFieldStack.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 12, left: 24, bottom: 0, right: -24)
        )
    }
    
    fileprivate func configureViewModel() {
        viewModel.listener = { [weak self] state in
            guard let self = self else {return}
            switch state {
            case .loading:
                self.loadingView.startAnimating()
            case .loaded:
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                }
            case .success:
                DispatchQueue.main.async {
                    self.countryCollectionView.reloadData()
                }
            case .error(message: let message):
                showMessage(title: message)
            case .refreshed:
                DispatchQueue.main.async {
                    self.refreshController.endRefreshing()
                }
            }
        }
    }
    
    @objc private func refreshList() {
        viewModel.refreshAllCountryList()
    }
    
    @objc private func sortNameButtonClicked() {
        viewModel.sortNameToggle()
    }
    
    @objc private func sortAreaButtonClicked() {
        viewModel.sortAreaToggle()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText = searchTextfield.text
        viewModel.searchCountry(searchText ?? "")
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell else {
            return UICollectionViewCell()
        }
        
        guard let item = viewModel.getProtocol(index: indexPath.row) else {return UICollectionViewCell()}
        cell.configureCell(model: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.getCountry(index: indexPath.row)
        let controller = CountryDetailViewController(viewModel: CountryDetailViewModel(country: item!))
        let navController = UINavigationController(rootViewController: controller)
        
        controller.navigationItem.title = item?.titleString
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 60)
    }
}
