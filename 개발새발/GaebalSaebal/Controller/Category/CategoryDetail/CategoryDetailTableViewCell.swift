//
//  CategoryDetailTableViewCell.swift
//  GaebalSaebal
//
//  Created by 이봄이 on 2022/05/22.
//

//카테고리 내 기록 목록 셀

import UIKit

class CategoryDetailTableViewCell: UITableViewCell {

    
    var originContentWidth:CGFloat = 0.0
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
        originContentWidth = self.contentView.frame.size.width

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    func setupLayout() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.clipsToBounds = false
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        self.backgroundColor = UIColor.clear
//        self.contentView.frame.size = CGSize(width: 374, height: 30)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = self.contentView.frame.height/2
        self.contentView.layer.masksToBounds = true
        
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()

        //한번 조정된 적이 있으면 inset 설정 X
        if self.contentView.frame.width > originContentWidth - 40 {
            self.layer.frame = self.layer.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))

            self.contentView.frame.size.width -= 40
        }
    }
}

