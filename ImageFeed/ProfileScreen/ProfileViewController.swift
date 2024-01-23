//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 26.11.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    
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
    
    
//    struct ProfileResult: Decodable {
//        let userName: String
//        let firstName: String
//        let lastName: String
//        let bio: String
//    }
    
    //var dataDecoded: ProfileResult?
    //var data: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //profileService.convertTask()
        //profile = profileService.profile
        //print(profileService.profile ?? "zero")
        
        
        
        
        //profileService.fetchProfile(<#T##token: String##String#>, completion: <#T##(Result<ProfileService.Profile, Error>) -> Void#>)
        //print(OAuth2Service().authToken!)
        //guard let profile = profileService.profile else { return }
        //self.profileLoginNameLabel?.text = profile.username
        
        
//        Task {
//            let result = try await profileService.fetchProfile(_: OAuth2Service().authToken!)
//            
//            let username = result.username
//            let name = result.firstName + " " + (result.lastName ?? "")
//            let loginName = "@" + result.username
//            let bio = result.bio ?? ""
//            
//            
//            
//        }
        
        
//        profileService.fetchProfile(OAuth2Service().authToken!) { result in
//            switch result {
//            case .success(let data):
//                //self.profileLoginNameLabel?.text = data.username
//                //self.profilePersonNameLabel?.text = data.firstName
//                
//                print(result)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        let authToken = OAuth2TokenStorage().token
//        let url = URL(string: "https://unsplash.com/me")
//        var request = URLRequest(url: url!)
//        request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
//        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
//            if let data = data {
//                DispatchQueue.main.async {
//                    self.profileLoginNameLabel?.text = "Димон"
//                    self.data = data
//                }
//                
//            }
//            
//        })
//        dataTask.resume()
//        //let dataDecoded = try JSONDecoder().decode(ProfileResult, from: data!)
//        func loadMovies(handler: @escaping (Result<ProfileResult, Error>) -> Void) {
//            
//                
//                case .success(let data):
//                    do {
//                        let mostPopularMovies = try JSONDecoder().decode(ProfileResult.self, from: data)
//                        handler(.success(mostPopularMovies))
//                    } catch {
//                        handler(.failure(error))
//                    }
//                case .failure(let error):
//                    handler(.failure(error))
//                
//            
//        }
        
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        setUpViewAndConstraints()
        
        updateProfileDetails()
        updateAvatar()
    }
    
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
    
    func updateProfileDetails() {
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
    
    
    private func setMainBgColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
    @objc private func buttonClicked() {
        // Do something
        
    }
    
}

extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
