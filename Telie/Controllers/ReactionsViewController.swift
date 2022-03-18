//
//  ReactionsViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 3/8/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class ReactionsViewController: UIViewController {
    
    // MARK: - Private View Vars
    private var reactionsTableView: UITableView!
    private var reactionsCollectionView: UICollectionView!
    
    // MARK: - Table View Sections
    private struct Section {
        let type: SectionType
    }

    private enum SectionType {
        case reaction
        case comments
    }
    
    // MARK: - Data Vars
    private var sections: [Section] = []
    private var reactionName: String = "Cindy"
    private var reactionProfilePic: String = "https://ca.slack-edge.com/T02A2C679-UNM3E26BF-6cbf92410a3b-192"
    private var reactionContent: String = "totally was\nnot expecting when they killed the \nold man TT \n\ni'm going to have an actual heart attack"
    private var timeSince = "1d"
    
    private var commentNames: [String] = ["Renee", "Renee", "Renee", "Renee", "Renee", "Renee"]
    private var commentProfilePics: [String] = ["https://ca.slack-edge.com/T02A2C679-UTRUDG1JR-4df533288128-192", "https://ca.slack-edge.com/T02A2C679-UTRUDG1JR-4df533288128-192", "https://ca.slack-edge.com/T02A2C679-UTRUDG1JR-4df533288128-192","https://ca.slack-edge.com/T02A2C679-UTRUDG1JR-4df533288128-192", "https://ca.slack-edge.com/T02A2C679-UTRUDG1JR-4df533288128-192", "https://ca.slack-edge.com/T02A2C679-UTRUDG1JR-4df533288128-192"]
    private var commentContent: [String] = [
        "let me tell you that \nshit ended meeeeeeeeeeeeeeeeeeeeeeeeee",
        "oops",
        "i need medication",
        "let me tell you that shit ended meeee\neeeeeeeeeeeeeeeeeeeeee",
        "oo\nps",
        "i need medication",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Squid Game"
        view.backgroundColor = .offWhite
        
        setupSections()
        
        reactionsTableView = UITableView(frame: .zero, style: .plain)
        reactionsTableView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        reactionsTableView.dataSource = self
        reactionsTableView.delegate = self
        reactionsTableView.backgroundColor = .clear
        reactionsTableView.allowsMultipleSelection = false
        reactionsTableView.isScrollEnabled = true
        reactionsTableView.alwaysBounceVertical = true
        reactionsTableView.bounces = true
        reactionsTableView.showsVerticalScrollIndicator = false
        reactionsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        reactionsTableView.register(ReactionsReactionTableViewCell.self, forCellReuseIdentifier: ReactionsReactionTableViewCell.reuseIdentifier)
        reactionsTableView.register(ReactionsCommentTableViewCell.self, forCellReuseIdentifier: ReactionsCommentTableViewCell.reuseIdentifier)
        reactionsTableView.separatorStyle = .none
        view.addSubview(reactionsTableView)
    
  
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           setupNavigationBar()
       }
    
    private func setupSections() {
        let reactionSection = Section(type: .reaction)
        let commentsSection = Section(type: .comments)
        sections = [reactionSection, commentsSection]
    }
    
    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)
        let iconButtonSize = CGSize(width: 30, height: 30)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.07
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    
        let infoButton = UIButton()
        infoButton.setImage(UIImage(named: "settingsInfoIcon"), for: .normal)
        infoButton.tintColor = .black
        infoButton.snp.makeConstraints { make in
            make.size.equalTo(iconButtonSize)
        }
        infoButton.addTarget(self, action: #selector(iconButtonPressed), for: .touchUpInside)
        let infoButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoButtonItem
    }
    
    @objc private func backButtonPressed() {
        print("back button pressed")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func iconButtonPressed() {
        print("icon button pressed")
        navigationController?.popViewController(animated: true)
    }


    private func setupConstraints() {
        reactionsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

    }
}

extension ReactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        let headerView = UIView()
        switch section.type {
        
        case .reaction:
            headerView.backgroundColor = .clear
            return headerView
        case .comments:
            
            headerView.backgroundColor = .clear
            
            
            let headerLabel = UILabel()
            headerLabel.textColor = .lightGray
            headerLabel.font = .systemFont(ofSize: 12, weight: .medium)
            headerLabel.text = "\(commentContent.count) thoughts"
            
           
            headerView.addSubview(headerLabel)
            headerLabel.snp.makeConstraints { make in
                make.leading.bottom.equalToSuperview().inset(20)
            }
            
            let dividerView = UIView()
            dividerView.backgroundColor = .lightGray2
            headerView.addSubview(dividerView)
            dividerView.snp.makeConstraints { make in
                make.leading.equalTo(headerLabel).inset(70)
                make.height.equalTo(1)
                make.width.equalToSuperview().inset(55)
            }
            return headerView
        }
        
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .reaction:
            return 1
        case .comments:
            return commentContent.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .reaction:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReactionsReactionTableViewCell.reuseIdentifier, for: indexPath) as? ReactionsReactionTableViewCell else { return UITableViewCell() }
            cell.configure(reactionName: reactionName, reactionProfilePic: reactionProfilePic, reactionContent: reactionContent, timeSince: timeSince)
            return cell
            
        case .comments:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReactionsCommentTableViewCell.reuseIdentifier, for: indexPath) as? ReactionsCommentTableViewCell else { return UITableViewCell() }
            cell.configure(reactionName: commentNames[indexPath.row], reactionProfilePic: commentProfilePics[indexPath.row], reactionContent: commentContent[indexPath.row], timeSince: timeSince)
            return cell
        }
        
    }
    
}
