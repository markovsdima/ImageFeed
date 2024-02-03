//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 26.12.2023.
//

import ProgressHUD
import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let splashLogo = UIImage(named: "LaunchScreenLogo")
    private var splashLogoImageView: UIImageView?
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMainBgColor(UIColor.ypBlack)
        setupSplashLogoImageView(with: splashLogo)
        setupSplashLogoImageViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if oauth2TokenStorage.token != nil {
            convertAndGet()
        } else {
            showAuthViewController()
        }
    }
    
    // MARK: - Private Methods
    private func showAuthViewController() {
        guard let authViewController = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(
            withIdentifier: "AuthViewController"
        ) as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

private extension SplashViewController {
    func setMainBgColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
    func setupSplashLogoImageView(with logo: UIImage?) {
        let imageView = UIImageView(image: logo)
        view.addSubview(imageView)
        self.splashLogoImageView = imageView
    }
    
    private func setupSplashLogoImageViewConstraints() {
        guard let imageView = splashLogoImageView else { return }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.convertAndGet()
                
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showErrorAlert()
                break
            }
        }
    }
    
    private func convertAndGet() {
        UIBlockingProgressHUD.show()
        Task {
            do {
                guard let token = oauth2TokenStorage.token else { return }
                try await profileService.convertTask(token)
                UIBlockingProgressHUD.dismiss()
                switchToTabBarController()
                try await profileImageService.fetchProfileImageURL(token, username: profileService.profile?.username)
            } catch {
                UIBlockingProgressHUD.dismiss()
                showErrorAlert()
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Ок",
            style: .default) { _ in
                alert.dismiss(animated: true)
            }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension SplashViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
