//
//  ReusableTextField.swift
//  BankingApp
//
//  Created by Narmin Baghirova on 15.11.24.
//

import UIKit

class ReusableTextField: UITextField {
    private var placeholderTitle: String?
    private var iconName: String?
    private var iconSetting: Int?
    
    init(placeholder: String!, placeholderSize: Int = 12, iconName: String?, iconSetting: Int = 10) {
        self.placeholderTitle = placeholder
        self.iconName = iconName
        self.iconSetting = iconSetting
        super.init(frame: .zero)
        configurePlaceholder(size: placeholderSize)
        configureIcon()
    }
    
    init(placeholder: String!, placeholderSize: Int = 12) {
        self.placeholderTitle = placeholder
        super.init(frame: .zero)
        configurePlaceholder(size: placeholderSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePlaceholder(size: Int) {
        attributedPlaceholder = NSAttributedString(string: placeholderTitle ?? "", attributes: [.foregroundColor:UIColor.lightGray, .font: UIFont(name: "Futura", size: CGFloat(size))!])
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 12
    }
    
    private func configureIcon() {
        leftView = iconUISetting(iconName ?? "", x: iconSetting ?? 10)
        leftViewMode = .always
    }
    
    fileprivate func iconUISetting(_ iconName: String, x: Int = 10) -> UIView {
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = .black
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: icon.frame.height))
        icon.frame = CGRect(x: CGFloat(integerLiteral: x), y: 0, width: icon.frame.width, height: icon.frame.height)
        paddingView.addSubview(icon)
        return paddingView
    }
}
