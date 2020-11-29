//
//  InputContainerView.swift
//  ChipChat
//
//  Created by Alexander Ha on 11/27/20.
//

import UIKit

class InputContainerView: UIView {
    
    init(image: String, textField: UITextField) {
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: image)
        iv.tintColor = .white
        iv.alpha = 0.87
        
        addSubview(iv)
        iv.centerY(inView: self)
        iv.anchor(leading: leadingAnchor, paddingLeading: 8)
        iv.setDimensions(height: 24, width: 28)
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(leading: iv.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingLeading: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingLeading: 8, height: 0.75)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
