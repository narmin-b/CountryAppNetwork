//
//  CountryDetailViewController.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 12.12.24.
//

import UIKit

enum infoList: String, CaseIterable {
    case region
    case area
    case capital
    case population
    case currency
}

class CountryDetailViewController: BaseViewController {
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.tintColor = .black
        view.hidesWhenStopped = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var detailTableView: UITableView = {
        let table = UITableView()
        table.register(cell: CountryDetailTableCell.self)
        table.delegate = self
        table.dataSource = self
        table.anchorSize(.init(width: 160, height: 0))
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var infoTableView: UITableView = {
        let table = UITableView()
        table.register(cell: CountryDetailTableCell.self)
        table.delegate = self
        table.dataSource = self
        table.anchorSize(.init(width: 160, height: 0))
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoTableView, detailTableView])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var viewModel: CountryDetailViewModel

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: CountryDetailViewModel){
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
        view.addSubViews(loadingView, flagImageView, infoStack)
        view.bringSubviewToFront(loadingView)
    }
    
    override func configureConstraint() {
        loadingView.centerXToSuperview()
        loadingView.centerYToSuperview()
        flagImageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            padding: .init(top: 12, left: 0, bottom: 0, right: 0)
        )
        flagImageView.centerXToSuperview()
        infoStack.anchor(
            top: flagImageView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 12, left: 24, bottom: 0, right: -24)
        )
        detailTableView.anchor(
            top: infoStack.topAnchor,
            leading: detailTableView.trailingAnchor,
            bottom: infoStack.bottomAnchor,
            trailing: infoTableView.leadingAnchor,
            padding: .init(all: 0)
        )
        infoTableView.anchor(
            top: infoStack.topAnchor,
            leading: infoStack.leadingAnchor,
            bottom: infoStack.bottomAnchor,
            trailing: infoStack.trailingAnchor,
            padding: .init(all: 0)
        )
    }
    
    override func configureTargets() {
        
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
                print("success")
//                DispatchQueue.main.async {
//                    self.countryTableView.reloadData()
//                }
            case .error(message: let message):
                showMessage(title: message)
            }
        }
    }
}

extension CountryDetailViewController :UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        infoList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: CountryDetailTableCell.self, for: indexPath)
        
        if tableView == detailTableView {
            let field = infoList.allCases[indexPath.row]
            cell.configureCell(title: field)
        }
        else {
            let country = viewModel.getCountry()
            let field = infoList.allCases[indexPath.row]
            
            var subtitle: String
            switch field {
            case .region:
                subtitle = country.regionString
            case .area:
                subtitle = String(country.areaDbl)
            case .capital:
                subtitle = country.capitalString
            case .population:
                subtitle = String(country.populationInt)
            case .currency:
                subtitle = country.currencyString
            }
            print("info: ", subtitle)
            cell.configureCell(title: subtitle)
        }
        return cell
    }
}
