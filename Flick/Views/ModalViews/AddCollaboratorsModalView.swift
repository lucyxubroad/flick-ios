//
//  AddCollaboratorsModalView.swift
//  Flick
//
//  Created by Lucy Xu on 6/21/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit

class AddCollaboratorModalView: UIView {

    // MARK: - Private View Vars
    private var cancelButton = UIButton()
    private var collaboratorsTableView: UITableView!
    private let collaboratorsTitleLabel = UILabel()
    private let containerView = UIView()
    private let copyLinkButton = UIButton()
    private var doneButton = UIButton()
    private var inviteCollaboratorsTableView: UITableView!
    private let inviteSearchBar = SearchBar()
    private let inviteTitleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let noFriendsLabel = UILabel()

    // MARK: - Private Data Vars
    private var allFriends: [UserProfile] = []
    private var collaborators: [UserProfile]
    private var friends: [UserProfile] = []
    private var owner: UserProfile
    private var selectedCollaborators: [UserProfile] = []

    private let collaboratorCellReuseIdentifier = "CollaboratorCellReuseIdentifier"
    private let inviteCollaboratorCellReuseIdentifier = "InviteCollaboratorCellReuseIdentifier"

    weak var modalDelegate: ModalDelegate?
    weak var listSettingsDelegate: ListSettingsDelegate?

    init(owner: UserProfile, collaborators: [UserProfile]) {
        self.owner = owner
        self.collaborators = [owner] + collaborators
        self.selectedCollaborators = collaborators
        super.init(frame: .zero)
        setupViews()
    }

    func setupViews() {
        frame = UIScreen.main.bounds
        backgroundColor = UIColor.darkBlueGray2.withAlphaComponent(0.7)

        collaboratorsTitleLabel.text = "Collaborators"
        collaboratorsTitleLabel.textColor = .black
        collaboratorsTitleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(collaboratorsTitleLabel)

        cancelButton = RoundedButton(style: .gray, title: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        containerView.addSubview(cancelButton)

        doneButton = RoundedButton(style: .purple, title: "Done")
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        containerView.addSubview(doneButton)

        subtitleLabel.text = "Collaborators can add or remove media and collaborators. The owner can edit privacy settings."
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .darkBlueGray2
        subtitleLabel.font = .systemFont(ofSize: 12)
        containerView.addSubview(subtitleLabel)

        collaboratorsTableView = UITableView(frame: .zero, style: .plain)
        collaboratorsTableView.dataSource = self
        collaboratorsTableView.delegate = self
        collaboratorsTableView.allowsMultipleSelection = true
        collaboratorsTableView.isScrollEnabled = true
        collaboratorsTableView.alwaysBounceVertical = false
        collaboratorsTableView.showsVerticalScrollIndicator = false
        collaboratorsTableView.register(CollaboratorTableViewCell.self, forCellReuseIdentifier: collaboratorCellReuseIdentifier)
        collaboratorsTableView.separatorStyle = .none
        containerView.addSubview(collaboratorsTableView)

        inviteTitleLabel.text = "Invite"
        inviteTitleLabel.textColor = .black
        inviteTitleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(inviteTitleLabel)

        copyLinkButton.setTitle("Copy link", for: .normal)
        copyLinkButton.setTitleColor(.mediumGray, for: .normal)
        copyLinkButton.titleLabel?.font = .systemFont(ofSize: 10)
        copyLinkButton.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        containerView.addSubview(copyLinkButton)

        inviteSearchBar.placeholder = "Search friends"
        inviteSearchBar.delegate = self
        containerView.addSubview(inviteSearchBar)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        addSubview(containerView)

        setupConstraints()

        NetworkManager.getFriends { [weak self] friends in
            guard let self = self else { return }
            self.friends = friends
            self.setupFriendsView()
        }
    }

    private func setupConstraints() {
        let collaboratorCellHeight = 57
        let collaboratorsTitleLabelSize = CGSize(width: 117, height: 22)
        let copyLinkButtonSize = CGSize(width: 48, height: 12)
        let horizontalPadding = 24
        let inviteTitleLabelSize = CGSize(width: 48, height: 22)
        let noFriendsSectionViewHeight = 193
        let roundButtonSize = CGSize(width: 84, height: 40)
        let verticalPadding = 36

        let collaboratorsTableViewHeight = min(collaborators.count, 4) * collaboratorCellHeight
        let friendsTableViewHeight = min(friends.count, 4) * collaboratorCellHeight

        let inviteSectionHeight = friends.count > 0 ? friendsTableViewHeight : noFriendsSectionViewHeight
        // 227 is manually calculated height for container
        let containerHeight = inviteSectionHeight + collaboratorsTableViewHeight + Int(roundButtonSize.height) + 287

        let containerViewSize = CGSize(width: 325, height: containerHeight)

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(containerViewSize)
        }

        collaboratorsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(verticalPadding)
            make.leading.equalTo(containerView).offset(horizontalPadding)
            make.size.equalTo(collaboratorsTitleLabelSize)
        }

        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(62.5)
            make.size.equalTo(roundButtonSize)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }

        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(62.5)
            make.size.equalTo(roundButtonSize)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collaboratorsTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(collaboratorsTitleLabel)
            make.trailing.equalTo(containerView).inset(horizontalPadding)
        }

        collaboratorsTableView.snp.makeConstraints { make in
            make.leading.equalTo(collaboratorsTitleLabel)
            make.trailing.equalTo(containerView).inset(horizontalPadding)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.height.equalTo(collaboratorsTableViewHeight)
        }

        inviteTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collaboratorsTableView.snp.bottom).offset(20.5)
            make.leading.equalTo(collaboratorsTitleLabel)
            make.size.equalTo(inviteTitleLabelSize)
        }

        copyLinkButton.snp.makeConstraints { make in
            make.trailing.equalTo(containerView).inset(horizontalPadding)
            make.centerY.equalTo(inviteTitleLabel)
            make.size.equalTo(copyLinkButtonSize)
        }

        inviteSearchBar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(collaboratorsTableView)
            make.height.equalTo(36)
            make.top.equalTo(inviteTitleLabel.snp.bottom).offset(18)
        }

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })

    }

    private func setupFriendsView() {
        if friends.count > 0 {
            inviteCollaboratorsTableView = UITableView(frame: .zero, style: .plain)
            inviteCollaboratorsTableView.dataSource = self
            inviteCollaboratorsTableView.delegate = self
            inviteCollaboratorsTableView.allowsMultipleSelection = true
            inviteCollaboratorsTableView.isScrollEnabled = true
            inviteCollaboratorsTableView.alwaysBounceVertical = false
            inviteCollaboratorsTableView.showsVerticalScrollIndicator = false
            inviteCollaboratorsTableView.register(CollaboratorTableViewCell.self, forCellReuseIdentifier: collaboratorCellReuseIdentifier)
            inviteCollaboratorsTableView.separatorStyle = .none
            containerView.addSubview(inviteCollaboratorsTableView)

            let inviteCollaboratorsTableViewHeight = min(4, friends.count) * 57
            inviteCollaboratorsTableView.snp.makeConstraints { make in
                make.leading.equalTo(collaboratorsTitleLabel)
                make.trailing.equalTo(subtitleLabel)
                make.height.equalTo(inviteCollaboratorsTableViewHeight)
                make.top.equalTo(inviteSearchBar.snp.bottom).offset(17)
            }
        } else {
            noFriendsLabel.text = "Stop telling your friends what to watch when they always forget... \nTell them to join Flick!"
            noFriendsLabel.textColor = .darkBlue
            noFriendsLabel.numberOfLines = 0
            noFriendsLabel.font = .systemFont(ofSize: 12)
            noFriendsLabel.textAlignment = .center
            containerView.addSubview(noFriendsLabel)

            noFriendsLabel.snp.makeConstraints { make in
                make.leading.equalTo(collaboratorsTitleLabel)
                make.trailing.equalTo(subtitleLabel)
                make.top.equalTo(inviteSearchBar.snp.bottom).offset(17)
                make.height.equalTo(193)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func doneTapped() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
            self.listSettingsDelegate?.updateCollaborators(to: self.selectedCollaborators)
        }
    }

    @objc func cancelTapped() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
        }
    }

    @objc func copyLink() {

    }

}

extension AddCollaboratorModalView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == collaboratorsTableView ? collaborators.count : friends.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: collaboratorCellReuseIdentifier, for: indexPath) as? CollaboratorTableViewCell else { return UITableViewCell() }
        let collaborator = tableView == collaboratorsTableView ? collaborators[indexPath.row] : friends[indexPath.row]
        cell.configure(for: collaborator, isOwner: collaborator.id == owner.id)
        if selectedCollaborators.contains(where: { $0.id == collaborator.id }) {
            cell.isSelected = true
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.isSelected = true
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        let collaborator = tableView == collaboratorsTableView ? collaborators[indexPath.row] : friends[indexPath.row]
        selectedCollaborators.append(collaborator)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.isSelected = false
        tableView.deselectRow(at: indexPath, animated: true)
        let collaborator = tableView == collaboratorsTableView ? collaborators[indexPath.row] : friends[indexPath.row]
        selectedCollaborators.removeAll { $0.id == collaborator.id }
    }
}

extension AddCollaboratorModalView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if allFriends.count > 0 {
            if searchText == "" {
                friends = allFriends
            } else {
                friends = allFriends.filter { "\($0.firstName) \($0.lastName)".contains(searchText) }
            }
            inviteCollaboratorsTableView.reloadData()
        }
    }
}