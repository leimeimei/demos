//
//  BooksCell.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit

class BooksCell: UICollectionViewCell, Reusable {
    
    var url: URL?
    var title: String? {
        didSet {
            guard let title = self.title else { return }
            self.titleLabel.text = title
        }
    }
    var image: UIImage? {
        didSet {
            guard let img = self.image else { return }
            self.ThumpImageView.image = img
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
        self.neumorphism()
        
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - 48) / 2
        self.addSubview(ThumpImageView)
        ThumpImageView.frame = CGRect(x: 12, y: 12, width: cellWidth - 24, height: 190)
        self.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 12, y: 210, width: cellWidth - 16, height: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        ThumpImageView.image = nil
    }
    
    private lazy var ThumpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()
}
