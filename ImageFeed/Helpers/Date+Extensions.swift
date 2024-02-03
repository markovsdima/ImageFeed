//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 20.11.2023.
//

import Foundation

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

private let dateDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM YYYY"
    return dateFormatter
}()

extension Date {
    var dateTimeString: String { dateTimeDefaultFormatter.string(from: self) }
    var dateString: String { dateDefaultFormatter.string(from: self) }
}

