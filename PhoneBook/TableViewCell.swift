//
//  TableViewCell.swift
//  PhoneBook
//
//  Created by 최규현 on 4/18/25.
//

import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .white
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 30
        
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        
        return label
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    private func setupUI() {
        [image, nameLabel, numberLabel].forEach { contentView.addSubview($0) }
        
        image.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(image.snp.trailing).offset(10)
        }
        
        numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(40)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
