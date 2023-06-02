//
//  CategoryDetailViewController.swift
//  GaebalSaebal
//
//  Created by 이봄이 on 2022/05/14.
//

import UIKit
import CoreData

class CategoryDetailViewController: UIViewController,EditLogDelegate {
    
    //EditLog func
    func goEditLog(categoryIdx : Int ,recordIdx : Int) {
        let desStroyboard = UIStoryboard(name: "Write", bundle: nil)
        let pushVC = desStroyboard.instantiateViewController(withIdentifier: "WriteLog") as! WriteViewController
        pushVC.categoryIndex = categoryIdx
        pushVC.recordIdx = recordIdx
        pushVC.writeORedit = true
        self.navigationController?.pushViewController(pushVC, animated: true)
//        let newVC = self.storyboard?.instantiateViewController(identifier: "WriteLog")
//            newVC?.modalTransitionStyle = .coverVertical
//            newVC?.modalPresentationStyle = .automatic
//        self.present(newVC!, animated: true, completion: nil)

        
    }
    
//    var receiveCategoryTitle: String?
    
    @IBOutlet weak var CategoryDetailTableView: UITableView!
    
    var categoryIndex: Int = 0
    
    lazy var recordList:[NSManagedObject] = {
        return CoreDataFunc.fetchRecordList()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegateDataSource()
        setUpNaviTitle()
//        print(categoryIndex)
        CategoryDetailTableView.layer.borderColor = UIColor.clear.cgColor
        
    }
    override func viewWillAppear(_ animated: Bool) {
        recordList = CoreDataFunc.fetchRecordList()
        DispatchQueue.main.async {
            CoreDataFunc.setupRecordData(recordList: self.recordList)
            self.CategoryDetailTableView.reloadData()
        }
    }
    
    private func setUpNaviTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        navigationController?.navigationBar.topItem?.title = categoryArray1[categoryIndex]
        let buttonImg = UIImage(named: "write")
        let writeBtn = UIButton()
        writeBtn.setImage(buttonImg, for: .normal)
        let barbuttonItem = UIBarButtonItem(customView: writeBtn)
        barbuttonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barbuttonItem.customView?.heightAnchor.constraint(equalToConstant: 45).isActive = true
        barbuttonItem.customView?.widthAnchor.constraint(equalToConstant: 45).isActive = true
        self.navigationItem.rightBarButtonItem = barbuttonItem
        
        //클릭이벤트
        writeBtn.addTarget(self, action: #selector(tapWriteButton), for: .touchUpInside)
    }
    
    @objc func tapWriteButton(sender:UIGestureRecognizer){
            //클릭시 실행할 동작
        performSegue(withIdentifier: "showWriteViewinCategory", sender: nil)
        
    }
    
    
    
    func logWillDelete(categoryIdx:Int, recordIdx:IndexPath) {
        let alert = UIAlertController(title: nil, message: "이 기록을 삭제하시겠습니까?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (_) in
            if CoreDataFunc.deleteRecord(categoryIdx: categoryIdx, recordIdx: recordIdx) {
                recordArray[self.categoryIndex].remove(at: recordIdx.section)
                self.CategoryDetailTableView.deleteSections(IndexSet(integersIn: recordIdx.section...recordIdx.section), with: .fade)
            }
            
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

}

extension CategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recordArray[categoryIndex].count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = recordArray[categoryIndex]
//        print("\(index)")
        let body = index[indexPath.section].body
//        let date = index[indexPath.section]
        let tag = index[indexPath.section].tag
        let date = index[indexPath.section].recordDate
        let cell = self.CategoryDetailTableView.dequeueReusableCell(withIdentifier: "categoryContentsCell", for: indexPath) as! CategoryDetailTableViewCell
        cell.contentLabel.text = body
        cell.tagLabel.text = tag
        cell.dateLabel.text = date
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let delete = UIContextualAction(style: .normal, title: "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("delete!!")
                self.logWillDelete(categoryIdx: self.categoryIndex, recordIdx: indexPath)
                success(true)
            })
        
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func setUpDelegateDataSource() {
        self.CategoryDetailTableView.delegate = self
        self.CategoryDetailTableView.dataSource = self
    }
    //디테일 페이지로 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goDetail" {
            
            let CategoryDetailTableViewIndexPath = CategoryDetailTableView.indexPath(for: sender as! UITableViewCell)!
            let VCDest = segue.destination as! DetailViewController
            VCDest.categoryIndex = categoryIndex
            VCDest.recordIndex = CategoryDetailTableViewIndexPath.section
            
            VCDest.goEditLogDelegate = self

        }
        
        if segue.identifier == "showWriteViewinCategory" {
            let vc = segue.destination as! WriteViewController
            vc.categoryIndex = categoryIndex
            vc.writeORedit = false
        }
    }
    // - 가은
    
    
}
