//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitry Markovskiy on 07.11.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak private var likeButton: UIButton!
    @IBOutlet weak private var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func configDate(date: String) {
        dateLabel.text = date
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "Like Active") : UIImage(named: "Like Inactive")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
