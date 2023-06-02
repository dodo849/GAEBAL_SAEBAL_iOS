//
//  CategoryCollectionViewCell.swift
//  GaebalSaebal
//
//  Created by 이봄이 on 2022/05/14.
//

import Foundation
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var contentsList:[UILabel] = []
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        return stackView
    }()
    
    static var id: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last ?? ""
    }
    
    var myCategory: MyCategory? {
        didSet { bind() } //myCategory 값이 바뀔 때마다 bind() 호출함
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        print("setup View")
    }
    
    //스택뷰에 같은 데이터가 쌓이지 않도록 셀 재사용 시 스택뷰에 쌓여있는 라벨들 제거해줌
    override func prepareForReuse() {
        super.prepareForReuse()
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        containerView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25).isActive = true
        
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        
    }
    
    private func bind() {
        containerView.layer.borderColor = myCategory!.color.cgColor
        containerView.layer.borderWidth = 2
        containerView.layer.cornerRadius = 50
        titleLabel.text = myCategory?.commentString
        if let contentString = myCategory!.contentString {
            createContentsLabel(contentText: contentString)
        }
        setupContentsView(labels: contentsList)
        print("setup contents View")
    }
    
    private func createContentsLabel(contentText: [MyRecord]) {
        contentsList = []
        for text in contentText {
            //기록은 5개까지만! 최신순으로 보여줘야하긴 하는데 일단,,,,, 아무튼!
            if contentsList.count >= 5 {
                break
            }
            let contentLabel = UILabel()
            contentLabel.font = .systemFont(ofSize: 14)
            contentLabel.numberOfLines = 1
            contentLabel.lineBreakMode = .byTruncatingTail
            contentLabel.textColor = .darkGray
            contentLabel.text = text.body
            contentsList.append(contentLabel)
        }
    }
    private func setupContentsView(labels: [UILabel]) {
            for label in labels {
                self.stackView.addArrangedSubview(label)
            }
        }
   
}
