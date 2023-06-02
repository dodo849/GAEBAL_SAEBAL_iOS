//
//  SettingTableViewCell.swift
//  GaebalSaebal
//
//  Created by 김가은 on 2022/05/09.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Content_View: UIView!

    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLayout()
        print("## 연결")
//        Content_View.layer.borderWidth=1
//        Content_View.layer.borderColor = UIColor.lightGray.cgColor
//        Content_View.layer.cornerRadius=10
        Content_View.layer.masksToBounds = true
      
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
            self.Content_View.backgroundColor = UIColor.white
            
            self.Content_View.layer.cornerRadius = 20
            self.Content_View.layer.masksToBounds = true
            
            
        }

}
