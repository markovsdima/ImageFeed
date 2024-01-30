//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 07.11.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak private var likeButton: UIButton!
    @IBOutlet weak private var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell (image: UIImage, date: String, likeImage: UIImage) {
        cellImage.image = image
        dateLabel.text = date
        likeButton.setImage(likeImage, for: .normal)
    }
}
