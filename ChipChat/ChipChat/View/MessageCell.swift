//
//  MessageCell.swift
//  ChipChat
//
//  Created by Alexander Ha on 12/1/20.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    //MARK: -  Properties
    
    var message: Message? {
        didSet { configure() }
    }
    
    var bubbleLeadingAnchor: NSLayoutConstraint!
    var bubbleTrailingAnchor: NSLayoutConstraint!
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        return tv
    }()
    
    private let bubbleContainer: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2386585772, green: 0.6723814607, blue: 0.9697690606, alpha: 1)
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(leading: leadingAnchor,
                                bottom: bottomAnchor,
                                paddingLeading: 8,
                                paddingBottom: -4)
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: topAnchor, bottom: bottomAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        bubbleLeadingAnchor = bubbleContainer.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12)
        bubbleLeadingAnchor.isActive = false
        
        bubbleTrailingAnchor = bubbleContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        bubbleTrailingAnchor.isActive = false
        
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor,
                        leading: bubbleContainer.leadingAnchor,
                        bottom: bubbleContainer.bottomAnchor,
                        trailing: bubbleContainer.trailingAnchor,
                        paddingTop: 4,
                        paddingLeading: 12,
                        paddingBottom: 4,
                        paddingTrailing: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - Helpers

    func configure() {
        
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message)
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
        
        bubbleLeadingAnchor.isActive = viewModel.leadingAnchorActive
        bubbleTrailingAnchor.isActive = viewModel.trailingAnchorActive
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
    }
    
}
