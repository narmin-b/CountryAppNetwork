//
//  CountryDetailCollectionCell.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 13.12.24.
//

import UIKit

class CountryDetailCollectionCell: UICollectionViewCell {
  
    private lazy var titleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelColor: .secondaryLabel, labelSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureUI() {
        backgroundColor = .lightGray
        
        contentView.addSubview(titleLabel)
        titleLabel.fillSuperview(padding: .init(all: 12))
    }
    
    func configureCell(title: InfoList) {
        titleLabel.text = title.rawValue.capitalized
        titleLabel.font = UIFont(name: "Futura", size: 20)
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Futura", size: 18)
        titleLabel.fillSuperview(padding: .init(top: 12, left: 6, bottom: -12, right: -12))
    }
}
