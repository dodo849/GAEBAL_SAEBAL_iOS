//
//  DetailViewController.swift
//  GaebalSaebal
//
//  Created by 김가은 on 2022/04/30.
//

import UIKit
import SafariServices
import SwiftUI
protocol EditLogDelegate : class {
    func goEditLog(categoryIdx : Int ,recordIdx : Int)
}

class DetailViewController: UIViewController, UIContextMenuInteractionDelegate {
    // 수정,삭제 버튼
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_: [UIMenuElement]) -> UIMenu? in
                    
                    let btn1 = UIAction(title: "수정", image: UIImage(systemName: "")) { (UIAction) in
                                                print("수정 클릭됨")
                        
                        //수정 버튼 누르면 디테일 페이지 사라지고,goEditLog()이용해서 카테고리 디테일 페이지에서 수정 페이지로 이동
                        self.goEditLogDelegate?.goEditLog(categoryIdx: self.categoryIndex, recordIdx: self.recordIndex)
                        self.dismiss(animated: true)

                       
                        
                    }
                    let btn2 = UIAction(title: "삭제", image: UIImage(systemName: "")) { (UIAction) in
                        print("삭제 클릭됨")
                        let alert = UIAlertController(title: "기록 삭제", message: "기록을 삭제하시겠습니까?", preferredStyle: .alert)

                                let ok = UIAlertAction(title: "OK", style: .default) { (ok) in

                                    //DB에서 삭제하는 기능 추가
                                   //삭제 완료 알림
                                    let D_alert = UIAlertController(title: "삭제 완료", message: "삭제가 완료되었습니다.", preferredStyle: .alert)
                                    D_alert.addAction(ok)

                                    self.present(D_alert, animated: true, completion: nil)
                    
                                }

                                let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in

                                     //code

                                }

                                alert.addAction(cancel)

                                alert.addAction(ok)

                                self.present(alert, animated: true, completion: nil)
                    }
                    
                    return UIMenu(children: [btn1])
                }
    }
    // MARK: - Declaration
    var goEditLogDelegate : EditLogDelegate?
    
    var categoryIndex: Int = 0
    var recordIndex : Int = 0
    
    var git_link = ""
    var boj_link = ""
    
    
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var D_title: UILabel!
    @IBOutlet weak var D_contents: UIView!
    @IBOutlet weak var D_body: UITextView!
    @IBOutlet weak var D_tag: UILabel!
    @IBOutlet weak var D_date: UILabel!
    @IBOutlet weak var contexMenu: UIView!
    @IBOutlet weak var contents_label: UILabel!
    @IBOutlet weak var ed_button: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var D_img: UIImageView!
    @IBOutlet weak var git_type_view: UIView!
    @IBOutlet weak var git_repo: UILabel!
    @IBOutlet weak var git_Date: UILabel!
    @IBOutlet weak var git_type: UILabel!
    @IBOutlet weak var git_label: UILabel!
    @IBOutlet weak var git_contents: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        DataLoad()
        setupGitEvent()
        setupBoj()
        codeTextView.text=recordArray[categoryIndex][recordIndex].code
        D_body.text = recordArray[categoryIndex][recordIndex].body
        D_body.delegate = self
        codeTextView.delegate = self
        D_body.delegate?.textViewDidChange?(D_body)
        codeTextView.delegate?.textViewDidChange?(codeTextView)
        D_body.isScrollEnabled = false
        codeTextView.isScrollEnabled = true
        
        // Do any additional setup after loading the view.
        scrollview.contentSize = CGSize(width: scrollview.frame.width, height: 20000)
        navigationController?.hidesBarsOnSwipe = true
        
        //백준 누르면 웹뷰이동
        let tapGesture_bj = UITapGestureRecognizer(target: self, action: #selector(goBjLink(sender:)))
        D_contents.addGestureRecognizer(tapGesture_bj)
        
        //git 누르면 웹뷰이동
        let tapGesture_git = UITapGestureRecognizer(target: self, action: #selector(goGitLink(sender:)))
        git_contents.addGestureRecognizer(tapGesture_git)
        
        //수정 삭제버튼 생성
        let interaction = UIContextMenuInteraction(delegate: self)
        ed_button.addInteraction(interaction)
        D_img.image=UIImage(named: "exampleimage")
        
        
        codeTextViewCustom()
        setupImage()
    }
   
    
    //데이터 로드 및 세팅 함수
    func DataLoad (){
        
        let index = recordArray[categoryIndex][recordIndex]
        D_title.text = "\(categoryArray1[categoryIndex])의 \(recordIndex + 1)번째 기록"
        D_tag.text = index.tag
        D_date.text = index.recordDate
        
    }
    //view custom
 
    
    func setupBoj(){
        let recordData = recordArray[categoryIndex][recordIndex]
        if (recordData.bojNumber?.isEmpty != true) {
            let bojContentsLabel = recordData.bojNumber!+"번 -"+recordData.bojTitle!
            D_contents.layer.borderWidth = 0.3
            D_contents.layer.borderColor = UIColor.lightGray.cgColor
            D_contents.layer.cornerRadius=50
            D_contents.layer.shadowColor = UIColor.gray.cgColor
            D_contents.layer.shadowRadius = 8
            D_contents.layer.shadowOffset = CGSize(width: 0, height: 4)
            D_contents.layer.shadowOpacity = 0.3
            contents_label.text = bojContentsLabel
            boj_link = "https://www.acmicpc.net/problem/\(recordData.bojNumber!)"
        }
        else {
            D_contents.isHidden = true
        }
    }
    
    func setupGitEvent(){
        let recordData = recordArray[categoryIndex][recordIndex]
        if (recordData.gitTitle != nil) {
            let gitEventTitle = recordData.gitTitle
            let gitEventRepo = recordData.gitRepoName!
            let gitEventType = recordData.gitType
            let gitEventDate = recordData.gitDate
            let gitEventNumber = recordData.eventNumber
            git_contents.layer.borderWidth = 0.3
            git_contents.layer.borderColor = UIColor.lightGray.cgColor
            git_contents.layer.cornerRadius = 50
            git_contents.layer.shadowColor = UIColor.gray.cgColor
            git_contents.layer.shadowRadius = 8
            git_contents.layer.shadowOffset = CGSize(width: 0, height: 4)
            git_contents.layer.shadowOpacity = 0.3
            git_label.text = gitEventTitle
            git_repo.text = gitEventRepo
            git_type.text = gitEventType
            git_Date.text = gitEventDate
            let greenLabelColor = UIColor.init(red: 77/255, green: 168/255, blue: 86/255, alpha: 1)
            let blueLabelColor = UIColor.init(red: 48/255, green: 141/255, blue: 181/255, alpha: 1)
            let redLabelColor = UIColor.init(red: 185/255, green: 54/255, blue: 54/255, alpha: 1)
            git_type_view.layer.borderWidth = 2
            git_type.font = UIFont.boldSystemFont(ofSize: 13.0)
            let typeLabelHeight: CGFloat = 30
            git_type_view.heightAnchor.constraint(equalToConstant: typeLabelHeight).isActive = true
            // 모서리 둥글게
            git_type_view.layer.cornerRadius = git_type_view.frame.height / 2
            if (gitEventType == "commit"){
                git_type_view.layer.borderColor = greenLabelColor.cgColor
                git_type.textColor = greenLabelColor
        

                git_link = "https://github.com/" + gitEventRepo + "/commits/" + (gitEventNumber!)
            } else if(gitEventType == "issue") {
                git_type_view.layer.borderColor = redLabelColor.cgColor
                git_link = "https://github.com/" + gitEventRepo + "/issues/" + gitEventNumber!

                git_type.textColor = redLabelColor

            } else if(gitEventType == "pull request") {
                git_type_view.layer.borderColor = blueLabelColor.cgColor

                git_link = "https://github.com/" + gitEventRepo + "pulls/" + gitEventNumber!

                git_type.textColor = blueLabelColor
            }
//            git_type_view.layer.cornerRadius=15
        }
        else {
            print("git 비었엄")
            git_contents.isHidden = true
        }
    }
    func setupImage() {
        let recordData = recordArray[categoryIndex][recordIndex]
        if recordData.image != nil {
            D_img.image = UIImage(data: recordData.image!)
        }
        else {
            D_img.isHidden = true
        }
    }
    //백준 터치시 링크로 이동
    @objc func goBjLink(sender:UIGestureRecognizer){
        let contentsUrl = NSURL(string: boj_link)
        let LinkSafariView: SFSafariViewController = SFSafariViewController(url: contentsUrl as! URL)
        self.present(LinkSafariView, animated: true, completion: nil)
    }
    //github 터치시 링크로 이동
    @objc func goGitLink(sender:UIGestureRecognizer){
        let contentsUrl = NSURL(string: git_link)
        let LinkSafariView: SFSafariViewController = SFSafariViewController(url: contentsUrl as! URL)
        self.present(LinkSafariView, animated: true, completion: nil)
    }
    //스크롤뷰
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard velocity.y != 0 else { return }
            if velocity.y < 0 {
                let height = self?.tabBarController?.tabBar.frame.height ?? 0.0
                self?.tabBarController?.tabBar.alpha = 1.0
                self?.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - height)
            } else {
                self?.tabBarController?.tabBar.alpha = 0.0
                self?.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
            }
        }
    }
    //textView 동적 레이아웃
    func textViewAutoLayout(){
//        D_body.translatesAutoresizingMaskIntoConstraints = false
        D_contents.translatesAutoresizingMaskIntoConstraints = true
        //백준, git 둘다 없을 때
//        D_body.topAnchor.constraint(equalTo:D_title.bottomAnchor, constant: 40.0).isActive = true
        //백준, git 하나만 없을 때
//        D_contents.topAnchor.constraint(equalTo:D_title.bottomAnchor, constant: 30.0).isActive = true
//        D_body.topAnchor.constraint(equalTo:D_contents.bottomAnchor, constant: 140.0).isActive = true
    }
 
    func codeTextViewCustom(){
        if (codeTextView.text == ""){
            codeTextView.isHidden = true
        }
        print("%%%\(codeTextView.text)")
        codeTextView.layer.cornerRadius = 20
        codeTextView.layer.backgroundColor =  UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        codeTextView.layer.borderWidth = 1.5
        codeTextView.layer.borderColor =  UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        codeTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15);

        codeTextView.textColor = .gray
        D_body.layer.cornerRadius = 20
        D_body.layer.borderWidth = 0.5
        D_body.layer.borderColor =  UIColor.lightGray.cgColor
        D_body.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15);


    }
    
    
    //디테일 뷰 모달창 닫는 함수
    @IBAction func close_log(_ sender: Any) {
        self.dismiss(animated: true)
    }
    //수정 및 삭제 버튼
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DetailViewController : UITextViewDelegate{
    //동적으로 textview 크기 늘리기
    
    func textViewDidChange(_ D_body: UITextView) {
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = D_body.sizeThatFits(size)
        D_body.constraints.forEach{(constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height+50.0
            }
        }
    }
//
}
