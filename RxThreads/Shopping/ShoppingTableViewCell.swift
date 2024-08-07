//
//  ShoppingTableViewCell.swift
//  RxThreads
//
//  Created by 최민경 on 8/7/24.
//
import UIKit
import SnapKit

final class ShoppingTableViewCell: UITableViewCell {
    static let identifier = "ShoppingTableViewCell"
    
    private let backView = UIView()
    let checkButton = UIButton()
    let listLabel = UILabel()
    let starButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        setupUI()
    }
    

    private func configureHierarchy() {
        contentView.addSubview(backView)
        backView.addSubview(checkButton)
        backView.addSubview(listLabel)
        backView.addSubview(starButton)
    }
    
    private func configureLayout() {
        backView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        checkButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(backView)
            make.leading.equalTo(backView.snp.leading).offset(16)
        }
      
        listLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(16)
            make.centerY.equalTo(backView.snp.centerY)
        }

        starButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(backView.snp.centerY)
            make.leading.greaterThanOrEqualTo(listLabel.snp.trailing).offset(12)
            make.trailing.equalTo(backView.snp.trailing).inset(16)
        }
    
    }
    
    private func setupUI() {
        checkButton.tintColor = .black
        checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        backView.layer.cornerRadius = 8
        backView.backgroundColor = .systemGray6
        selectionStyle = .none
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
