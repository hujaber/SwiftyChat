//
//  SharedPropertyCell.swift
//  ChatPrototype
//
//  Created by Hussein Jaber on 29/9/19.
//  Copyright © 2019 Hussein Jaber. All rights reserved.
//

import UIKit

class IncomingSharedPropertyCell: UITableViewCell {
    
    class var identifier: String {
        "IncomingSharedProperty"
    }


    public var isIncoming: Bool {
        return true
    }
    
    public var bundle: Bundle {
        return .init(for: Self.self)
    }
    
    public var cellBackGroundColor: UIColor = UIColor.init(white: 241.0/255.0, alpha: 1) {
        didSet {
            cellBackgroundView.backgroundColor = self.cellBackGroundColor
        }
    }
    
    private let iconImageView = UIImageView()
    private let cellBackgroundView = UIView()
    private let propertyImageView = UIImageView()
    private let propertyTextLabel = UILabel()
    private let propertyDetailsLabel = UILabel()
    private let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        defer {
            activateConstraints()
        }
        
        if #available(iOS 13, *) {
            contentView.backgroundColor = .systemBackground
        } else {
            contentView.backgroundColor = .white
        }
        
        setupBackgroundView()
        setupIconImageView()
        setupPropertyImageView()
        setupPropertyTextLabel()
        setupPropertyDetailsLabel()
        setupDateLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        iconImageView.layer.cornerRadius = 25
        cellBackgroundView.layer.cornerRadius = 10
    }
    
    private func setupBackgroundView() {
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        cellBackgroundView.backgroundColor = cellBackGroundColor
        cellBackgroundView.clipsToBounds = true
        contentView.addSubview(cellBackgroundView)
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.layer.borderColor = UIColor.systemGray.cgColor
        iconImageView.layer.borderWidth = 1.0
        iconImageView.image = UIImage(named: "Profile", in: bundle, compatibleWith: nil)
        iconImageView.clipsToBounds = true
        
        contentView.addSubview(iconImageView)
    }
    
    private func setupPropertyImageView() {
        propertyImageView.translatesAutoresizingMaskIntoConstraints = false
        propertyImageView.image = UIImage(named: "property", in: bundle, compatibleWith: nil)
        propertyImageView.contentMode = .scaleAspectFill
        propertyImageView.clipsToBounds = true
        cellBackgroundView.addSubview(propertyImageView)
    }
    
    private func setupPropertyTextLabel() {
        propertyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        propertyTextLabel.text = "Beirut, Down Town"
        
        cellBackgroundView.addSubview(propertyTextLabel)
    }
    
    private func setupPropertyDetailsLabel() {
        
    }
    
    private func setupDateLabel() {
        timeLabel.applyTimeLabelProperties()
        contentView.addSubview(timeLabel)
    }
    
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5),
            timeLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -15)
        ])
        
        if self.isIncoming {
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
                
            ])
        } else {
            NSLayoutConstraint.activate([
                iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            ])
        }
        
        NSLayoutConstraint.activate([
            cellBackgroundView.heightAnchor.constraint(equalToConstant: 120),
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        if isIncoming {
            NSLayoutConstraint.activate([
                
                cellBackgroundView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
                cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
                
            ])
        } else {
            NSLayoutConstraint.activate([
                cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
                cellBackgroundView.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -10)
            ])
        }
        
        NSLayoutConstraint.activate([
            propertyImageView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor),
            propertyImageView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor),
            propertyImageView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor),
            propertyImageView.heightAnchor.constraint(equalTo: cellBackgroundView.heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            propertyTextLabel.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 10),
            propertyTextLabel.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -10),
            propertyTextLabel.topAnchor.constraint(equalTo: propertyImageView.bottomAnchor, constant: 8),
        ])
    }
}



class OutgoingSharedProperty: IncomingSharedPropertyCell {
    
    override class var identifier: String {
        "OutgoingSharedProperty"
    }

    override var isIncoming: Bool {
        false
    }

}

extension UILabel {
    func applyTimeLabelProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        var labelColor: UIColor
        if #available(iOS 13, *) {
            labelColor = .systemGray2
        } else {
            labelColor = .lightGray
        }
        self.textColor = labelColor
        self.textAlignment = .center
        self.font = .systemFont(ofSize: 9)
        self.text = "3:43PM"
    }
}
