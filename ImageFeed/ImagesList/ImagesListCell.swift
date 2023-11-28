//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 07.11.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak private var cellImage: UIImageView!
    @IBOutlet weak private var likeButton: UIButton!
    @IBOutlet weak private var dateLabel: UILabel!
    
    func configCell (image: UIImage, date: String, likeImage: UIImage) {
        cellImage.image = image
        dateLabel.text = date
        likeButton.setImage(likeImage, for: .normal)
    }
}
