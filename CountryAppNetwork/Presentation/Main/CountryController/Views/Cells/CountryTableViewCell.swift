//
//  CountryTableViewCell.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 07.12.24.
//

import UIKit

class CountryTableViewCell: UICollectionViewCell {
    private lazy var countryLabel: UILabel = {
        let label = ReusableLabel(labelText: "Test", labelSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.anchorSize(.init(width: 64, height: 32))
        imageView.backgroundColor = .clear
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var cellStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [flagImageView, countryLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    fileprivate func configureView() {
        addSubview(cellStack)
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        cellStack.fillSuperview(padding: .init(top: 12, left: 12, bottom: -12, right: 0))
    }
    
    func configureCell(model: TitleImageProtocol) {
        backgroundColor = .backgroundSecondary
        layer.cornerRadius = 8
        
        countryLabel.text = model.titleString
        flagImageView.loadImageURL(url: model.imageString)
    }
}
