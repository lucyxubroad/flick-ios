//
//  CollaboratorTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 6/21/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class CollaboratorTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let isSelectedIndicatorImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ownerLabel = UILabel()
    private let selectIndicatorView = UIView()
    private let userImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .black
        addSubview(nameLabel)

        ownerLabel.text = "Owner"
        ownerLabel.font = .systemFont(ofSize: 16)
        ownerLabel.textColor = .mediumGray

        userImageView.layer.cornerRadius = 20
        userImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        addSubview(userImageView)

        selectIndicatorView.layer.cornerRadius = 10
        selectIndicatorView.layer.borderWidth = 2
        selectIndicatorView.layer.backgroundColor = UIColor.white.cgColor
        selectIndicatorView.isHidden = true
        addSubview(selectIndicatorView)

        isSelectedIndicatorImageView.image = UIImage(named: "isSelectedIndicator")
        isSelectedIndicatorImageView.isHidden = true
        addSubview(isSelectedIndicatorImageView)

        setupConstraints()
    }

    func configure(for collaborator: Collaborator) {
        nameLabel.text = collaborator.name
//        userImageView.image = UIImage(named: collaborator.image)
        if collaborator.isOwner {
            addSubview(ownerLabel)
            setupOwnerConstraints()
        } else {
            setupNonOwnerConstraints()
            isSelectedIndicatorImageView.isHidden = !collaborator.isAdded
            selectIndicatorView.layer.borderColor = collaborator.isAdded ? UIColor.gradientPurple.cgColor : UIColor.lightGray.cgColor
            selectIndicatorView.isHidden = false
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let isSelectedIndicatorSize = CGSize(width: 10, height: 8)
        let selectIndicatorSize = CGSize(width: 20, height: 20)
        let userImageSize = CGSize(width: 40, height: 40)

        userImageView.snp.makeConstraints { make in
            make.size.equalTo(userImageSize)
            make.centerY.leading.equalToSuperview()
        }

        selectIndicatorView.snp.makeConstraints { make in
            make.size.equalTo(selectIndicatorSize)
            make.centerY.trailing.equalToSuperview()
        }

        isSelectedIndicatorImageView.snp.makeConstraints { make in
            make.center.equalTo(selectIndicatorView)
            make.size.equalTo(isSelectedIndicatorSize)
        }
    }

    private func setupOwnerConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(16)
            make.top.equalTo(userImageView)
        }
        ownerLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
    }

    private func setupNonOwnerConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }

}
