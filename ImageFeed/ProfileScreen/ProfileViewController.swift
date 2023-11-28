//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 26.11.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    let defaultProfileImage = UIImage(systemName: "person.crop.circle.fill")!
    let profileImage = UIImage(named: "ProfilePhoto")
    let profilePersonName = "Екатерина Новикова"
    let profileLoginName = "@ekaterina_nov"
    let profileDescription = "Hello, world!"
    
    private var profileImageView: UIImageView?
    private var profilePersonNameLabel: UILabel?
    private var profileLoginNameLabel: UILabel?
    private var profileDescriptionLabel: UILabel?
    private var profileLogoutButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMainBgColor(named: "YP Black")
        
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
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupProfilePersonNameLabel(with name: String) {
        let label = UILabel()
        label.text = name
        label.textColor = UIColor(named: "YP White")
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
        label.textColor = UIColor(named: "YP Grey")
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
        label.textColor = UIColor(named: "YP White")
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
        
        button.tintColor = UIColor(named: "YP Red")
        view.addSubview(button)
        self.profileLogoutButton = button
    }
    
    private func setupProfileLogoutButtonConstraints() {
        guard let button = profileLogoutButton else { return }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: profileImageView!.centerYAnchor)
        ])
    }
    
    
    private func setMainBgColor(named color: String) {
        view.backgroundColor = UIColor(named: color)
    }
    
    @objc private func buttonClicked() {
        // Do something
        
    }
    
}
