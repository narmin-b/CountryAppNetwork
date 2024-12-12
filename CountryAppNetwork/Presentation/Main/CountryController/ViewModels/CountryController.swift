//
//  MainViewController.swift
//  CountryAppNetwrok
//
//  Created by Narmin Baghirova on 04.12.24.
//

import UIKit

class MainViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var countryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cell: CountryTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
    
    override func configureView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        view.addSubViews(loadingView, countryTableView, searchFieldStack)
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
        countryTableView.anchor(
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
                    self.countryTableView.reloadData()
                }
            case .error(message: let message):
                showMessage(title: message)
            }
        }
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

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: CountryTableViewCell.self, for: indexPath)
        guard let item = viewModel.getProtocol(index: indexPath.row) else {return UITableViewCell()}
        cell.configureCell(model: item)
        return cell
    }
}
