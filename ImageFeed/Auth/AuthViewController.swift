//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 03.12.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

class AuthViewController: UIViewController {
    private let authLogo = UIImage(named: "auth_screen_logo")
    
    private var authLogoImageView: UIImageView?
    private var loginButton: UIButton?
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMainBgColor(UIColor.ypBlack)
        setupAuthLogoImageView(with: authLogo)
        setupAuthLogoImageViewConstraints()
        setupLoginButtonView()
        setupLoginButtonViewConstraints()
    }
    
    private func setupAuthLogoImageView(with logo: UIImage?) {
        let imageView = UIImageView(image: logo)
        view.addSubview(imageView)
        self.authLogoImageView = imageView
    }
    
    private func setupAuthLogoImageViewConstraints() {
        guard let imageView = authLogoImageView else { return }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLoginButtonView() {
        let button = UIButton(type: .custom)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor.ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        view.addSubview(button)
        self.loginButton = button
    }
    
    private func setupLoginButtonViewConstraints() {
        guard let button = loginButton else { return }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 48),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    private func setMainBgColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
    @objc private func loginButtonClicked() {
        self.performSegue(withIdentifier: ShowWebViewSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
