//
//  GithubRepoTableViewCell.swift
//  GaebalSaebal
//
//  Created by DOYEONLEE2 on 2022/05/17.
//

import UIKit

class GithubRepoTableViewCell: UITableViewCell {
    @IBOutlet weak var repoNameLabel: UILabel!
    
    var originContentWidth:CGFloat = 0.0
    
    let mainPink = UIColor(red: 250/255, green: 0/255, blue: 255/255, alpha: 1)
    let mainPurple = UIColor(red: 178/255, green: 14/255, blue: 255/255, alpha: 1)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupLayout()
        
        // 원래 contetnView 넓이 기억하기
        print("### cell view frame width : \(self.originContentWidth)")
//        originContentWidth = self.contentView.frame.size.width
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        

        
        if(selected) {
            self.contentView.layer.borderWidth = 1
            self.contentView.layer.borderColor = mainPink.cgColor

        } else {
            self.contentView.layer.borderWidth = 0
        }
    }
    
    func setupLayout() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.clipsToBounds = false
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 12
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 2
        self.contentView.layer.masksToBounds = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        //한번 조정된 적이 있으면 inset 설정 X
        if self.contentView.frame.width != originContentWidth - 40 {
            self.layer.frame = self.layer.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            
            self.contentView.frame.size.width = originContentWidth - 40
        }

    }

}
