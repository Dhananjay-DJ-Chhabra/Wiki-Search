//
//  SearchResultTableViewCell.swift
//  Wiki Search
//
//  Created by Dhananjay Chhabra on 18/10/23.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"
    
    private let iconView: UIImageView = {
        let icon = UIImageView()
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 5
        icon.backgroundColor = .red
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private var titleLeadingConstraint = NSLayoutConstraint()
//    private var subtitleLeadingConstraint = NSLayoutConstraint()
//    var iconWidthConstraint = NSLayoutConstraint()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(title: String, subtitle: String, iconUrl: String?){
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        guard let url = iconUrl else { return }
        iconView.sd_setImage(with: URL(string: url))
    
    }
    
    func setUpView(){
        contentView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconView.heightAnchor.constraint(equalToConstant: 45),
            iconView.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        contentView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
}
