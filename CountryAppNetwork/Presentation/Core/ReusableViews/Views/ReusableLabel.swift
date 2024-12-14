//
//  ReusableLabel.swift
//  BankingApp
//
//  Created by Narmin Baghirova on 22.11.24.
//

import UIKit

class ReusableLabel: UILabel {
    private var labelText: String!
    private var labelColor: UIColor?
    private var labelFont: UIFont?
    
    init(labelText: String!, labelColor: UIColor? = .black, labelFont: String? = "Futura", labelSize: Int? = 12) {
        self.labelText = labelText
        self.labelColor = labelColor
        self.labelFont = UIFont(name: labelFont ?? "Futura", size: CGFloat(integerLiteral: labelSize ?? 0))
        super.init(frame: .zero)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        text = labelText
        textColor = labelColor
        textAlignment = .left
        font = labelFont
        numberOfLines = 1
    }
}
