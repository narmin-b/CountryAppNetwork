//
//  CountryDetailCollectionCell.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 13.12.24.
//

import UIKit

class CountryDetailCollectionCell: UICollectionViewCell {
  
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: "Futura", size: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: "Futura", size: 16)
        label.textColor = .secondaryLabel
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
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.backgroundColor = .systemBackground
    }
    
    func configureCell(title: InfoList) {
        titleLabel.text = title.rawValue.capitalized
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
    }
}
