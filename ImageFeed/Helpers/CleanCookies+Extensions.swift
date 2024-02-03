//
//  CleanCookies+Extensions.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 02.02.2024.
//

import Foundation
import WebKit

final class CleanCookies {
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
