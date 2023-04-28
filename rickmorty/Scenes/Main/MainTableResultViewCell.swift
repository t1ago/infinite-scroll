//
//  MainTableResultViewCell.swift
//  rickmorty
//
//  Created by Tiago Henrique Piantavinha on 26/04/23.
//

import UIKit

class MainTableResultViewCell: UITableViewCell {
    
    static let REUSABLE_IDENTIFIER = "MainTableResultViewCell"
    private let MARGIN_SIZE = 8.0
    private let PHOTO_SIZE = 100.0
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .whiteLigth
        view.applyCornerRadius()
        return view
    }()
    
    lazy var photo: UIImageView = {
        let image = UIImageView(image: UIImage(named: "loading"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.applyCornerRadius()
        return image
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Name"
        label.textColor = .greenDark
        label.font = .boldSystemFont(ofSize: 16.0)
        return label
    }()
    
    lazy var species: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Specie"
        label.textColor = .greenMedium
        label.font = .systemFont(ofSize: 12.0)
        return label
    }()
    
    lazy var location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Location"
        label.textColor = .greenMedium
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .greenLight
        contentView.addSubview(container)
        container.addSubview(photo)
        container.addSubview(name)
        container.addSubview(species)
        container.addSubview(location)
        configureLayout()
    }
    
    @available(*, deprecated, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureCell(character: CharacterModel) {
        name.text = character.name
        species.text = character.species
        location.text = character.location.name
        if let url = character.image {
            photo.load(url: url)
        }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MARGIN_SIZE),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: MARGIN_SIZE * -1),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            photo.topAnchor.constraint(equalTo: container.topAnchor, constant: MARGIN_SIZE),
            photo.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: MARGIN_SIZE),
            photo.heightAnchor.constraint(equalToConstant: PHOTO_SIZE),
            photo.widthAnchor.constraint(equalToConstant: PHOTO_SIZE),
            photo.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: MARGIN_SIZE * -1),
            
            name.topAnchor.constraint(equalTo: photo.topAnchor, constant: MARGIN_SIZE),
            name.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: MARGIN_SIZE),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: MARGIN_SIZE * -1),
            
            species.topAnchor.constraint(equalTo: name.bottomAnchor),
            species.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            species.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            location.topAnchor.constraint(equalTo: species.bottomAnchor, constant: MARGIN_SIZE),
            location.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            location.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
        ])
    }
    
}
