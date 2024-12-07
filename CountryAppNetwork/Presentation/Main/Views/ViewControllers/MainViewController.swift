//
//  MainViewController.swift
//  CountryAppNetwrok
//
//  Created by Narmin Baghirova on 04.12.24.
//

import UIKit

class MainViewController: UIViewController {
    private var viewModel: MainViewModel

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: MainViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func configureViewModel() {
        viewModel.listener = { [weak self] state in
            guard let self = self else {return}
            switch state {
                case .loading:
                    print("loading")
            case .loaded:
                print("loaded")
            case .success:
                print("success")
            case .error(message: let message):
                print("error: \(message)")
            }
        }
    }
    
}
