//
//  HistoryCell.swift
//  iBookExample
//
//  Created by sun on 2021/12/23.
//

import UIKit
import SnapKit

class HistoryCell: UITableViewCell, Reusable {
    
    var url: NSURL?
    var title: String? {
        didSet {
            guard let title = self.title else { return }
            self.titleLabel.text = title
        }
    }
    
    var author: String? {
        didSet {
            guard let author = self.author else { return }
            self.authorLabel.text = "作者: " + author
        }
    }
    
    var image: UIImage? {
        didSet {
            guard let img = self.image else { return }
            self.thumbImageView.image = img
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Device.bgColor
        selectionStyle = .none
        addSubview(cellBgView)
        cellBgView.frame = CGRect(x: 16, y: 8, width: UIScreen.main.bounds.width - 32, height: 120)
        cellBgView.neumorphism()
        cellBgView.addSubview(thumbImageView)
        thumbImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 72, height: 120 - 16))
        }
        cellBgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-26)
            make.left.equalTo(thumbImageView.snp.right).offset(16)
            make.width.equalTo(Device.kWidth - 160)
        }
        cellBgView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(24)
            make.left.equalTo(thumbImageView.snp.right).offset(16)
            make.width.equalTo(Device.kWidth - 160)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        thumbImageView.image = nil
    }
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = ""
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.text = ""
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()
    
    private lazy var cellBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
}
