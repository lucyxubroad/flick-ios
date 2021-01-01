//
//  EditProfileViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class ProfileInputTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .systemFont(ofSize: 12)
        textColor = .black
        borderStyle = .none
        layer.backgroundColor = UIColor.offWhite.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.mediumGray.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: frame.height))
        leftViewMode = .always
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class EditProfileViewController: UIViewController {

    // MARK: - Private View Vars
    private let accountInfoDescriptionLabel = UILabel()
    private let accountInfoTitleLabel = UILabel()
    private let bioFieldLabel = UILabel()
    private let bioTextView = UITextView()
    private let bioTextLimitLabel = UILabel()
    private let editProfileTitleLabel = UILabel()
    private let facebookAccountLabel = UILabel()
    private let facebookFieldLabel = UILabel()
    private let firstNameFieldLabel = UILabel()
    private let firstNameTextField = ProfileInputTextField()
    private let headerView = UIView()
    private let imagePickerController = UIImagePickerController()
    private let lastNameFieldLabel = UILabel()
    private let lastNameTextField = ProfileInputTextField()
    private let profileImageView = UIImageView()
    private let profileSelectionModalView = ProfileSelectionModalView()
    private let selectImageButton = UIButton()
    private let userNameFieldLabel = UILabel()
    private let userNameTextField = ProfileInputTextField()

    // MARK: - Private Data Vars
    private let userDefaults = UserDefaults.standard
    private let profileImageSize = CGSize(width: 100, height: 100)

    override func viewDidLoad() {
        view.backgroundColor = .offWhite
        setupNavigationBar()

        profileSelectionModalView.modalDelegate = self
        profileSelectionModalView.profileSelectionDelegate = self

        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]

        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        view.addSubview(profileImageView)

        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        selectImageButton.setImage(UIImage(named: "editButton"), for: .normal)
        selectImageButton.clipsToBounds = false
        selectImageButton.layer.masksToBounds = false
        // TODO: Double check shadows
        selectImageButton.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        selectImageButton.layer.shadowOpacity = 0.07
        selectImageButton.layer.shadowOffset = .init(width: 0, height: 4)
        selectImageButton.layer.shadowRadius = 8
        view.addSubview(selectImageButton)

        firstNameFieldLabel.text = "First Name"
        firstNameFieldLabel.font = .systemFont(ofSize: 8)
        firstNameFieldLabel.textColor = .mediumGray
        view.addSubview(firstNameFieldLabel)

        view.addSubview(firstNameTextField)

        lastNameFieldLabel.text = "Last Name"
        lastNameFieldLabel.font = .systemFont(ofSize: 8)
        lastNameFieldLabel.textColor = .mediumGray
        view.addSubview(lastNameFieldLabel)

        view.addSubview(lastNameTextField)

        userNameFieldLabel.text = "Username"
        userNameFieldLabel.font = .systemFont(ofSize: 8)
        userNameFieldLabel.textColor = .mediumGray
        view.addSubview(userNameFieldLabel)

        view.addSubview(userNameTextField)

        bioFieldLabel.text = "Bio"
        bioFieldLabel.font = .systemFont(ofSize: 8)
        bioFieldLabel.textColor = .mediumGray
        view.addSubview(bioFieldLabel)

        bioTextLimitLabel.text = "0 / 100"
        bioTextLimitLabel.textAlignment = .right
        bioTextLimitLabel.font = .systemFont(ofSize: 8)
        bioTextLimitLabel.textColor = .mediumGray
        view.addSubview(bioTextLimitLabel)

        bioTextView.delegate = self
        bioTextView.sizeToFit()
        bioTextView.isScrollEnabled = false
        bioTextView.font = .systemFont(ofSize: 12)
        bioTextView.textColor = .black
        bioTextView.layer.backgroundColor = UIColor.offWhite.cgColor
        bioTextView.layer.masksToBounds = false
        bioTextView.layer.shadowColor = UIColor.mediumGray.cgColor
        bioTextView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bioTextView.layer.shadowOpacity = 1.0
        bioTextView.layer.shadowRadius = 0.0
        view.addSubview(bioTextView)

        accountInfoTitleLabel.text = "Linked Accounts and Information"
        accountInfoTitleLabel.font = .systemFont(ofSize: 16)
        accountInfoTitleLabel.textColor = .black
        view.addSubview(accountInfoTitleLabel)

        accountInfoDescriptionLabel.text = "Linked Accounts allow you to find friends you know but won't post to other accounts."
        accountInfoDescriptionLabel.textColor = .mediumGray
        accountInfoDescriptionLabel.font = .systemFont(ofSize: 10)
        accountInfoDescriptionLabel.numberOfLines = 0
        view.addSubview(accountInfoDescriptionLabel)

        facebookFieldLabel.text = "Facebook"
        facebookFieldLabel.font = .systemFont(ofSize: 8)
        facebookFieldLabel.textColor = .mediumGray
        view.addSubview(facebookFieldLabel)

        facebookAccountLabel.text = "Alanna Zhou"
        facebookAccountLabel.font = .systemFont(ofSize: 12)
        facebookAccountLabel.textColor = .black
        view.addSubview(facebookAccountLabel)

        setupConstraints()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)
        // TODO: Update save button size
        let saveButtonSize = CGSize(width: 33, height: 17)

        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        editProfileTitleLabel.text = "Edit Profile"
        editProfileTitleLabel.font = .systemFont(ofSize: 18)
        editProfileTitleLabel.textColor = .black
        navigationController?.navigationBar.addSubview(editProfileTitleLabel)

        editProfileTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(59)
            make.top.bottom.trailing.equalToSuperview()
        }

        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.gradientPurple, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 14)
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(saveButtonSize)
        }

        saveButton.addTarget(self, action: #selector(saveProfileInformation), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButtonItem

        headerView.backgroundColor = .movieWhite
        headerView.clipsToBounds = false
        headerView.layer.masksToBounds = false
        // TODO: Double check tab bar shadows
        headerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        headerView.layer.shadowOpacity = 0.07
        headerView.layer.shadowOffset = .init(width: 0, height: 4)
        headerView.layer.shadowRadius = 8
        view.addSubview(headerView)

        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(10)
        }

    }

    private func setupConstraints() {

        let editButtonSize = CGSize(width: 24, height: 24)
        let horizontalPadding = 24
        let profileImageSize = CGSize(width: 100, height: 100)
        let smallFieldSize = CGSize(width: 152, height: 17)
        let verticalPadding = 20

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(profileImageSize)
        }

        selectImageButton.snp.makeConstraints { make in
            make.size.equalTo(editButtonSize)
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(horizontalPadding/2)
        }

        firstNameFieldLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.trailing.equalTo(view.snp.centerX).offset(-horizontalPadding/2)
        }

        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameFieldLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(firstNameFieldLabel)
            make.height.equalTo(smallFieldSize.height)
        }

        lastNameFieldLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.leading.equalTo(view.snp.centerX).offset(horizontalPadding/2)
            make.top.equalTo(firstNameFieldLabel)
        }

        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameFieldLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(lastNameFieldLabel)
            make.height.equalTo(smallFieldSize.height)
        }

        userNameFieldLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(firstNameFieldLabel)
            make.top.equalTo(firstNameTextField.snp.bottom).offset(verticalPadding)
        }

        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameFieldLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(userNameFieldLabel)
            make.height.equalTo(smallFieldSize.height)
        }

        bioFieldLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(firstNameFieldLabel)
            make.trailing.equalTo(bioTextLimitLabel.snp.leading)
        }

        bioTextLimitLabel.snp.makeConstraints { make in
            make.trailing.equalTo(lastNameTextField)
            make.top.equalTo(bioFieldLabel)
            make.width.equalTo(38)
        }

        bioTextView.snp.makeConstraints { make in
            make.top.equalTo(bioFieldLabel.snp.bottom).offset(4)
            make.leading.equalTo(bioFieldLabel)
            make.trailing.equalTo(bioTextLimitLabel)
        }

        accountInfoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bioTextView.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }

        accountInfoDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(accountInfoTitleLabel)
            make.top.equalTo(accountInfoTitleLabel.snp.bottom).offset(6)
        }

        facebookFieldLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(accountInfoTitleLabel)
            make.top.equalTo(accountInfoDescriptionLabel.snp.bottom).offset(verticalPadding)
        }

        facebookAccountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(accountInfoTitleLabel)
            make.top.equalTo(facebookFieldLabel.snp.bottom).offset(4)
        }

    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func selectImage() {
        // TODO: Revisit if having multiple scenes becomes an issue (for ex. with iPad)
        showModalPopup(view: profileSelectionModalView)
    }

    @objc func saveProfileInformation() {
        if let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let username = userNameTextField.text,
            let bio = bioTextView.text,
            let base64ProfileImage = profileImageView.image?.toBase64()
        {
            let user = User(username: username, firstName: firstName, lastName: lastName, profilePic: base64ProfileImage, bio: bio, phoneNumber: "7812289951")
            NetworkManager.updateUserProfile(user: user) { [weak self] userProfile in
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editProfileTitleLabel.removeFromSuperview()
    }

}

extension EditProfileViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        // Attempt to read the range they are trying to change, or terminate if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // Add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        let charCount = updatedText.count
        bioTextLimitLabel.text = "\(charCount) / 150"
        return charCount <= 150
    }

}

extension EditProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let resizedImage = image.resize(toSize: profileImageSize, scale: UIScreen.main.scale)
        profileImageView.image = resizedImage
        profileSelectionModalView.removeFromSuperview()
        dismiss(animated: true, completion: nil)

    }
}

extension EditProfileViewController: ModalDelegate, ProfileSelectionDelegate {
    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

    func selectFromGallery() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func takeNewPhoto() {
        profileSelectionModalView.removeFromSuperview()
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }


}