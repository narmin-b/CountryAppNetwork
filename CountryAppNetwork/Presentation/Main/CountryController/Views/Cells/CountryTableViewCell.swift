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
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
//        stack.anchorSize(.init(width: 40, height: 0))
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        cellStack.fillSuperview(padding: .init(top: 12, left: 0, bottom: -12, right: 0))
    }
    
    func configureCell(model: TitleImageProtocol) {
        countryLabel.text = model.titleString
        flagImageView.loadImageURL(url: model.imageString)
    }
}
