//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 03.12.2023.
//

import UIKit
import WebKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

class WebViewViewController: UIViewController {
    private var webView: WKWebView?
    private var navBackButton: UIButton?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupWebViewConstraints()
        setupNavBackButtonView()
        setupNavBackButtonViewConstraints()
        loadRequest()
        
        webView?.navigationDelegate = self
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
                                           action: #selector(self.navBackButtonClicked))
        
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
    
    private func loadRequest() {
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView?.load(request)
        
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
         if let code = code(from: navigationAction) {
                //TODO: process code
                decisionHandler(.cancel)
          } else {
                decisionHandler(.allow)
            }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
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
    
    @objc func navBackButtonClicked() {
        
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
