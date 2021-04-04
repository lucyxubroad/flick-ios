//
//  AddCollaboratorViewController.swift
//  Telie
//
//  Created by Lucy Xu on 3/31/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddCollaboratorViewController: UIViewController {

    // MARK: - Private View Vars
    private var collaboratorsTableView: UITableView!
    private let collaboratorsTitleLabel = UILabel()
    private var inviteCollaboratorsTableView: UITableView!
    private let inviteSearchBar = SearchBar()
    private let inviteTitleLabel = UILabel()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .ballSpinFadeLoader,
        color: .gradientPurple
    )
    private let subtitleLabel = UILabel()
    private var currentSearchText = ""

    // MARK: - Private Data Vars
    private var allFriends: [UserProfile] = []
    private let collaboratorCellHeight = 57
    private var collaborators: [UserProfile]
    private var friends: [UserProfile] = []
    private var listFriends: [UserProfile] = []
    private var owner: UserProfile
    private let addCollaboratorButton = UIButton()

    private var editMode = "Remove"

    weak var listSettingsDelegate: ListSettingsDelegate?

    init(owner: UserProfile, collaborators: [UserProfile]) {
        self.owner = owner
        self.collaborators = [owner] + collaborators
        self.listFriends = [owner] + collaborators
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        collaboratorsTitleLabel.text = "Collaborators"
        collaboratorsTitleLabel.textColor = .black
        collaboratorsTitleLabel.font = .boldSystemFont(ofSize: 18)
        view.addSubview(collaboratorsTitleLabel)

        subtitleLabel.text = "Collaborators can add or remove media and collaborators. The owner can edit privacy settings."
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .darkBlueGray2
        subtitleLabel.font = .systemFont(ofSize: 12)
        view.addSubview(subtitleLabel)

        collaboratorsTableView = UITableView(frame: .zero, style: .plain)
        collaboratorsTableView.dataSource = self
        collaboratorsTableView.delegate = self
        collaboratorsTableView.allowsMultipleSelection = true
        collaboratorsTableView.isScrollEnabled = true
        collaboratorsTableView.alwaysBounceVertical = false
        collaboratorsTableView.showsVerticalScrollIndicator = false
        collaboratorsTableView.register(EditUserTableViewCell.self, forCellReuseIdentifier: EditUserTableViewCell.reuseIdentifier)
        collaboratorsTableView.separatorStyle = .none
        view.addSubview(collaboratorsTableView)

        setupConstraints()

        NetworkManager.getFriends { [weak self] friends in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.allFriends = friends
                self.friends = friends
                self.listFriends = self.editMode == "Remove" ? self.collaborators : friends
                self.spinner.stopAnimating()
            }
        }

    }

    @objc func addCollaboratorButtonPressed() {

    }

    private func setupConstraints() {
        let collaboratorsTitleLabelSize = CGSize(width: 117, height: 22)
        let horizontalPadding = 24
        let verticalPadding = 36

        collaboratorsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalPadding)
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.size.equalTo(collaboratorsTitleLabelSize)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collaboratorsTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(collaboratorsTitleLabel)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        inviteSearchBar.placeholder = "Search friends"
        inviteSearchBar.delegate = self
        view.addSubview(inviteSearchBar)

        inviteSearchBar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(collaboratorsTableView)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.height.equalTo(40)
        }

        collaboratorsTableView.snp.makeConstraints { make in
            make.leading.equalTo(collaboratorsTitleLabel)
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(inviteSearchBar.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCollaborators(updatedList: MediaList) {
        collaborators = [updatedList.owner] + updatedList.collaborators
        collaboratorsTableView.reloadData()
        inviteCollaboratorsTableView.reloadData()
    }
}

extension AddCollaboratorViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("tableview")
        let headerView = UIView()
        headerView.backgroundColor = .white
        let headerLabel = UILabel()
        headerLabel.textColor = .darkBlueGray2
        headerLabel.font = .boldSystemFont(ofSize: 12)
        headerLabel.text = editMode == "Invite" ? "Friends" : "Collaborators"
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFriends.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditUserTableViewCell.reuseIdentifier, for: indexPath) as? EditUserTableViewCell else { return UITableViewCell() }
        let collaborator = listFriends[indexPath.row]
        if editMode == "Remove" {
            cell.configureForRemove(user: collaborator, isOwner: owner.id == collaborator.id)
        } else {
            cell.configureForAdd(user: collaborator, isAdded: collaborators.contains { $0.id == collaborator.id })
        }
        cell.delegate = self
        return cell
    }
}

extension AddCollaboratorViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if currentSearchText.isEmpty {
            editMode = "Invite"
            listFriends = allFriends
            collaboratorsTableView.reloadData()
        }
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty && !currentSearchText.isEmpty {
            editMode = "Remove"
            listFriends = collaborators
        } else if searchText.isEmpty && currentSearchText.isEmpty {
            editMode = "Invite"
            listFriends = allFriends
        } else {
            editMode = "Invite"
            if allFriends.count > 0 {
                if searchText == "" {
                    listFriends = allFriends
                } else {
                    listFriends = allFriends.filter {
                        "\($0.name)".contains(searchText) || $0.username.contains(searchText)
                    }
                }
            }
        }
        currentSearchText = searchText
        collaboratorsTableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if currentSearchText.isEmpty {
            editMode = "Remove"
            listFriends = collaborators
        } else {
            editMode = "Invite"
        }
        collaboratorsTableView.reloadData()
    }

}

extension AddCollaboratorViewController: EditUserCellDelegate {

    func addUserTapped(user: UserProfile) {
        listSettingsDelegate?.addCollaborator(collaborator: user)
    }

    func removeUserTapped(user: UserProfile) {
        listSettingsDelegate?.removeCollaborator(collaborator: user)
    }

}