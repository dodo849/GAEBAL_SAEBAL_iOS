//
//  categoryTableViewCell.swift
//  GaebalSaebal
//
//  Created by 김가은 on 2022/05/13.
//

import UIKit
protocol AddCategoryDelegate {
    func AddCategory()
}

class categoryTableViewCell: UITableViewCell {
    @IBOutlet weak var Content_view: UIView!
    
    
    var cellDelegate : AddCategoryDelegate?
    
    @IBOutlet weak var categoryButton: UIButton!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.categoryButton.isHidden=true

    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    @objc func plusbtnClicked(sender:UIGestureRecognizer){
        cellDelegate?.AddCategory()


    }

   
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(plusbtnClicked(sender:)))
        categoryButton.addGestureRecognizer(tapGesture)
    }
    func setupLayout() {
            self.layer.shadowColor = UIColor.black.cgColor
            self.clipsToBounds = false
            self.layer.shadowOpacity = 0.1
            self.layer.shadowRadius = 12
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
            
            self.backgroundColor = UIColor.clear
            self.Content_view.backgroundColor = UIColor.white
            
            self.Content_view.layer.cornerRadius = 20
            self.Content_view.layer.masksToBounds = true
            
            
        }

}
