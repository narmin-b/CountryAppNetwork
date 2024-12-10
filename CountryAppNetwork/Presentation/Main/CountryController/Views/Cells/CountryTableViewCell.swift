//
//  CountryTableViewCell.swift
//  CountryAppNetwork
//
//  Created by Narmin Baghirova on 07.12.24.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.anchorSize(.init(width: 64, height: 32))
        imageView.backgroundColor = .clear
        imageView.layer.borderColor = UIColor.lightGray.cgColor
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

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
        configureConstraints()
    }
    
    fileprivate func configureView() {
        addSubViews(cellStack)
    }
    
    fileprivate func configureConstraints() {
        cellStack.fillSuperview(padding: .init(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    func configureCell(model: TitleImageProtocol) {
        countryLabel.text = model.titleString
        flagImageView.loadImageURL(url: model.imageString)
    }   
}
