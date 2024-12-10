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
        view.color = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
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
        view.addSubViews(loadingView, tableView)
    }
    
    override func configureTargets() {
        
    }
    
    override func configureConstraint() {
        loadingView.fillSuperview()
        tableView.fillSuperview(padding: .init(all: 24))
    }
    
    fileprivate func configureViewModel() {
        viewModel.listener = { [weak self] state in
            guard let self = self else {return}
            switch state {
            case .loading:
                loadingView.startAnimating()
            case .loaded:
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                }
                
            case .success:
                print("success")
            case .error(message: let message):
                showMessage(title: message)
            }
        }
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
