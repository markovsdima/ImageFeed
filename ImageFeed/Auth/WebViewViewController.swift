//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 03.12.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    private var webView: WKWebView?
    private var navBackButton: UIButton?
    private var progressView: UIProgressView?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupWebViewConstraints()
        setupNavBackButtonView()
        setupNavBackButtonViewConstraints()
        setupProgressView()
        setupProgressViewConstraints()
        loadRequest()
        
        webView?.navigationDelegate = self
        
        estimatedProgressObservation = webView?.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }
    
    private func updateProgress() {
        guard let progressView, let webView else { return }
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func setupProgressView() {
        let progressView = UIProgressView()
        progressView.progressTintColor = UIColor.ypBackground
        progressView.progress = 0.5
        view.addSubview(progressView)
        self.progressView = progressView
    }
    
    private func setupProgressViewConstraints() {
        guard let progressView else { return }
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: navBackButton?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupWebView() {
        let webView = WKWebView()
        webView.backgroundColor = .black
        view.addSubview(webView)
        self.webView = webView
    }
    
    private func setupWebViewConstraints() {
        guard let webView else { return }
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func setupNavBackButtonView() {
        let button = UIButton.systemButton(with: UIImage(named: "nav_back_button")!,
                                           target: self,
                                           action: #selector(self.didTapBackButton))
        
        button.tintColor = UIColor.ypBlack
        
        view.addSubview(button)
        self.navBackButton = button
    }
    
    private func setupNavBackButtonViewConstraints() {
        guard let button = navBackButton else { return }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 64),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    @objc func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

private extension WebViewViewController {
    func loadRequest() {
        var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView?.load(request)
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
