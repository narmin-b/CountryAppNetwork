//
//  ReusableButton.swift
//  BankingApp
//
//  Created by Narmin Baghirova on 13.11.24.
//

import UIKit

class ReusableButton: UIButton {
    private var title: String!
    private var onAction: (() -> Void)
    
    
    init(title: String!, onAction: (@escaping () -> Void)) {
        self.title = title
        self.onAction = onAction
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        setAttributedTitle(NSAttributedString(string: title, attributes: [.font: UIFont(name: "Futura", size: 18)!]), for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .lightGray
        layer.cornerRadius = 12
        titleLabel?.textAlignment = .center
        layer.masksToBounds = true
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
       
    @objc private func buttonTapped() {
        onAction()
    }
}
