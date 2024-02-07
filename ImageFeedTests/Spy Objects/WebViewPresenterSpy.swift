//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Dmitry Markovskiy on 03.02.2024.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) { }
    
    func code(from url: URL) -> String? { nil }
    
}
