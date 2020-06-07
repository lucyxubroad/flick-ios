//
//  DiscoverViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    // MARK: - Private View Vars
    // TODO: Remove dummy label
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .lightPurple

        titleLabel.text = "Discover"
        titleLabel.font = .systemFont(ofSize: 32)
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().offset(24)
            make.height.equalTo(50)
        }

    }

}

