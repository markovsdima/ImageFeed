//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 26.11.2023.
//

import Kingfisher
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let defaultProfileImage = UIImage(systemName: "person.crop.circle.fill")!
    private let profileImage = UIImage(named: "ProfilePhoto")
    private let profilePersonName = "Екатерина Новикова"
    private let profileLoginName = "@ekaterina_nov"
    private let profileDescription = "Hello, world!"
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileImageView: UIImageView?
    private var profilePersonNameLabel: UILabel?
    private var profileLoginNameLabel: UILabel?
    private var profileDescriptionLabel: UILabel?
    private var profileLogoutButton: UIButton?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        setUpViewAndConstraints()
        updateProfileDetails()
        updateAvatar()
    }
    
    // MARK: - Private Methods
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL),
            let profileImageView = profileImageView
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .clear)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named:"avatarPlaceholder"),
                                     options: [.processor(processor)])
        profileImageView.layer.cornerRadius = 35
        profileImageView.layer.masksToBounds = true
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        profileLoginNameLabel?.text = profile.loginName
        profilePersonNameLabel?.text = profile.name
        profileDescriptionLabel?.text = profile.bio
    }
    
    private func setUpViewAndConstraints() {
        setMainBgColor(UIColor.ypBlack)
        
        setupProfileImageView(with: profileImage)
        setupProfileImageViewConstraints()
        
        setupProfilePersonNameLabel(with: profilePersonName)
        setupProfilePersonNameLabelConstraints()
        
        setupProfileLoginNameLabel(with: profileLoginName)
        setupProfileLoginNameLabelConstraints()
        
        setupProfileDescriptionLabel(with: profileDescription)
        setupProfileDescriptionLabelConstraints()
        
        setupProfileLogoutButton()
        setupProfileLogoutButtonConstraints()
    }
    
    private func setupProfileImageView(with image: UIImage?) {
        let imageView = UIImageView(image: image ?? defaultProfileImage)
        imageView.tintColor = .gray
        view.addSubview(imageView)
        self.profileImageView = imageView
    }
    
    private func setupProfileImageViewConstraints() {
        guard let imageView = profileImageView else { return }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupProfilePersonNameLabel(with name: String) {
        let label = UILabel()
        label.text = name
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        view.addSubview(label)
        self.profilePersonNameLabel = label
    }
    
    private func setupProfilePersonNameLabelConstraints() {
        guard let label = profilePersonNameLabel else { return }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: profileImageView!.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: profileImageView!.leadingAnchor)
        ])
    }
    
    private func setupProfileLoginNameLabel(with login: String) {
        let label = UILabel()
        label.text = login
        label.textColor = UIColor.ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(label)
        self.profileLoginNameLabel = label
    }
    
    
    private func setupProfileLoginNameLabelConstraints() {
        guard let label = profileLoginNameLabel else { return }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: profilePersonNameLabel!.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: profilePersonNameLabel!.leadingAnchor)
        ])
    }
    
    private func setupProfileDescriptionLabel(with description: String) {
        let label = UILabel()
        label.text = description
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(label)
        self.profileDescriptionLabel = label
    }
    
    private func setupProfileDescriptionLabelConstraints() {
        guard let label = profileDescriptionLabel else { return }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: profileLoginNameLabel!.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: profileLoginNameLabel!.leadingAnchor)
        ])
    }
    
    private func setupProfileLogoutButton() {
        let button = UIButton.systemButton(with: UIImage(named: "Exit")!,
                                           target: self,
                                           action: #selector(self.buttonClicked))
        
        button.tintColor = UIColor.ypRed
        button.accessibilityIdentifier = "LogoutButton"
        view.addSubview(button)
        self.profileLogoutButton = button
    }
    
    private func setupProfileLogoutButtonConstraints() {
        guard let button = profileLogoutButton else { return }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: profileImageView!.centerYAnchor)
        ])
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.view.accessibilityIdentifier = "LogoutAlert"
        
        alert.addAction(UIAlertAction(
            title: "Да",
            style: .default
        ) { [weak self] action in
            guard let self = self else {return}
            profileService.logout()
            switchToSplashViewController()
        })
        
        alert.addAction(UIAlertAction(
            title: "Нет",
            style: .default
        ))
        
        present(alert, animated: true)
    }
    
    private func setMainBgColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
    @objc private func buttonClicked() {
        showLogoutAlert()
    }
}

extension ProfileViewController {
    func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { preconditionFailure("Invalid Configuration") }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}

extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
