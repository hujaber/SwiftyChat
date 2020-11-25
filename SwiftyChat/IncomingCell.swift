//
//  IncomingCell.swift
//  ChatPrototype
//
//  Created by Hussein Jaber on 26/9/19.
//  Copyright © 2019 Hussein Jaber. All rights reserved.
//

import UIKit

// - TODO: emoji case
// - TODO: Image

class IncomingCell: UITableViewCell {
    
    public class var identifier: String {
        "IncomingCell"
    }
    
    public var isIncoming: Bool {
        true
    }
    
    public var avatarBorderColor: UIColor = .lightGray {
        didSet {
            iconImageView.layer.borderColor = self.avatarBorderColor.cgColor
        }
    }
    
    public var bubbleBackgroundColor: UIColor = UIColor.init(white: 241.0/255.0, alpha: 1) {
        didSet {
            bubbleImageView.tintColor = self.bubbleBackgroundColor
        }
    }
    
    
    
    private var currentBundle: Bundle {
        .init(for: Self.self)
    }
    
    public var chatTextColor: UIColor = .black {
        didSet {
            chatTextLabel.textColor = chatTextColor
        }
    }
    
    private let iconImageView = UIImageView()
    private let bubbleImageView = UIImageView()
    private let chatTextLabel = UILabel()
    private let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defer {
            activateConstraints()
        }
        configureIconImageView()
        configureBubbleImageView()
        configureChatLabel()
        configureTimeLabel()
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        iconImageView.layer.cornerRadius = 25
    }
    
    private func configureIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.borderWidth = 1.0
        iconImageView.image = UIImage(named: "Profile", in: currentBundle, compatibleWith: nil)
        iconImageView.clipsToBounds = true
    }
    
    private func configureBubbleImageView() {
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        guard let bubbleImage = UIImage.init(named: isIncoming ? "incoming": "outgoing", in: currentBundle, compatibleWith: nil) else {
            fatalError()
        }
        
        bubbleImageView.image = bubbleImage.resizableImage(withCapInsets: .init(top: 17, left: 21, bottom: 17, right: 21))
            .withRenderingMode(.alwaysTemplate)
        bubbleImageView.tintColor = bubbleBackgroundColor
    }
    
    private func configureChatLabel() {
        chatTextLabel.translatesAutoresizingMaskIntoConstraints = false
        chatTextLabel.numberOfLines = 0
        chatTextLabel.textColor = chatTextColor
    }
    
    private func configureTimeLabel() {
        timeLabel.applyTimeLabelProperties()
    }
    
    private func addSubviews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(chatTextLabel)
        contentView.addSubview(timeLabel)
    }
    
    func activateConstraints() {
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5),
            timeLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor)
        ])
        
        // icon image constraints
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15),
        ])
        
        if isIncoming {
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
            ])
        } else {
            NSLayoutConstraint.activate([
                iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            ])
        }
        
        
        // bubble constraints
        NSLayoutConstraint.activate([
            bubbleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bubbleImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
        ])
        
        if isIncoming {
            NSLayoutConstraint.activate([
                bubbleImageView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
                bubbleImageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -60),
            ])
        } else {
            NSLayoutConstraint.activate([
                bubbleImageView.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10),
                bubbleImageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 60)
            ])
        }
        
        
        NSLayoutConstraint.activate([
            chatTextLabel.leadingAnchor.constraint(equalTo: bubbleImageView.leadingAnchor, constant: isIncoming ? 15: 10),
            chatTextLabel.topAnchor.constraint(equalTo: bubbleImageView.topAnchor, constant: 5),
            chatTextLabel.trailingAnchor.constraint(equalTo: bubbleImageView.trailingAnchor, constant: isIncoming ? -10 : -20),
            chatTextLabel.bottomAnchor.constraint(equalTo: bubbleImageView.bottomAnchor, constant: -5)
        ])
    }
    
    
    func setupWithMessage(_ message: Message) {
        chatTextLabel.text = message.text
        timeLabel.text = message.dateString
    }
    
    
}

class OutgoingCell: IncomingCell {
    override class var identifier: String {
        "OutgoingCell"
    }
    
    override var isIncoming: Bool {
        false
    }
}

extension String {
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.properties.isEmoji }
    }

    var containsOnlyEmoji: Bool {
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.properties.isEmoji && !$0.isZeroWidthJoiner
            })
    }

}

extension UnicodeScalar {
    var isZeroWidthJoiner: Bool {
           return value == 8205
       }
}
