//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 26.12.2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    private let splashLogo = UIImage(named: "LaunchScreenLogo")
    private var splashLogoImageView: UIImageView?
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMainBgColor(UIColor.ypBlack)
        setupSplashLogoImageView(with: splashLogo)
        setupSplashLogoImageViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if oauth2TokenStorage.token != nil {
            //fetchProfile(token: oauth2TokenStorage.token!)
            
            //profileService.convertTask()
            
            //switchToTabBarController()
            convertAndGet()
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
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
            //self.convertAndGet()
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.convertAndGet()
                //self.switchToTabBarController()
                //UIBlockingProgressHUD.dismiss()
                //self.fetchProfile(token: oauth2TokenStorage.token!)
                print("555")
            case .failure:
                // TODO [Sprint 11]
                
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func convertAndGet() {
        //try await profileService.fetchProfile(<#T##token: String##String#>)
        //switchToTabBarController()
        UIBlockingProgressHUD.show()
        Task {
            do {
                //try await profileService.fetchProfile(oauth2TokenStorage.token!)
                guard let token = oauth2TokenStorage.token else { return }
                try await profileService.convertTask(token)
                UIBlockingProgressHUD.dismiss()
                switchToTabBarController()
                try await profileImageService.fetchProfileImageURL(token, username: profileService.profile?.username)
                
            } catch {
                UIBlockingProgressHUD.dismiss()
                showErrorAlert()
                print("Request failed with error: \(error)")
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Ок",
            style: .default,
            handler: { _ in
                alert.dismiss(animated: true)
            })
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
//    private func fetchProfile(token: String) {
//        profileService.fetchProfile (token) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                UIBlockingProgressHUD.dismiss()
//                self.switchToTabBarController()
//            case .failure:
//                UIBlockingProgressHUD.dismiss()
//                // Показать ошибку TODO
//                break
//            }
//        }
//    }
    
    
    
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
