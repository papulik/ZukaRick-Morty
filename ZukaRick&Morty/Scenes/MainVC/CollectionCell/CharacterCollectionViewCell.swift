//
//  CharacterCollectionViewCell.swift
//  ZukaRick&Morty
//
//  Created by Zuka Papuashvili on 19.06.24.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    private let imageView = ZukasAsyncImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.numberOfLines = 0
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        imageView.loadImage(from: character.image)
    }
}
