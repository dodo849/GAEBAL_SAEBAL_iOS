//
//  categorySetViewController.swift
//  GaebalSaebal
//
//  Created by 김가은 on 2022/05/09.
//

import UIKit
import CoreData


class categorySetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AddCategoryDelegate{
    var addCategoryname = ""
    
    lazy var categoryList:[NSManagedObject] = {
        return CoreDataFunc.fetchCategoryList()
    }()
    
    func AddCategory() {
        let alert = UIAlertController(title: "카테고리명 입력", message: "추가할 카테고리명을 입력하세요", preferredStyle: .alert)

            let ok = UIAlertAction(title: "확인", style: .default) { (ok) in

                self.addCategoryname = alert.textFields?[0].text ?? ""
                print(self.addCategoryname)
                if (self.addCategoryname.count > 10) {
                    let alert = UIAlertController(title: "카테고리 제목은 10자를 초과할 수 없습니다.", message: "", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
                    let context = container.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "Category", in: context)
                
                    if let entity = entity {
                        let category = NSManagedObject(entity: entity, insertInto: context)
                        category.setValue(self.addCategoryname, forKey: "categoryName")
                        
                    }
                    do {
                        try context.save()
                        self.categoryList = CoreDataFunc.fetchCategoryList()
                        CoreDataFunc.setupCategoryData(categoryList: self.categoryList)
                        print(categoryArray1)
                        print("## 새 카테고리 추가 ~!")
                    } catch {
                        print("Error saving contet \(error)")
                    }
                    
                    if(self.addCategoryname != ""){
                        self.categorySet.beginUpdates()
                        self.categorySet.insertSections(IndexSet(categoryArray1.count-1...categoryArray1.count-1),with: UITableView.RowAnimation.automatic)
                        self.categorySet.endUpdates()
                    }
                }
                
            }

            let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in

                 //code

            }

            alert.addAction(cancel)

            alert.addAction(ok)
            alert.addTextField ()

            self.present(alert, animated: true, completion: nil)
    
    }
    
    
    // MARK: - Declaration
//    var categoryList = ["기본"]
    
    @IBOutlet weak var categorySet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.topItem?.title = "카테고리 추가 / 삭제"
        navigationItem.title = "카테고리 추가 / 삭제"
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        // Do any additional setup after loading the view.
        categorySet.dataSource=self
        categorySet.delegate=self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell",for: indexPath) as! categoryTableViewCell

        if (indexPath.section <= categoryArray1.count-1){
            print(indexPath.section)
            cell.textLabel?.text = categoryArray1[indexPath.section]
            cell.categoryButton.isHidden=true
        }else {
            cell.textLabel?.text = "추가하기"
            cell.categoryButton.isHidden=false
            cell.cellDelegate=self
        }
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryArray1.count+1
    }
    //섹션 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.9
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if ((indexPath.section<categoryList.count)&&( 0 < indexPath.section)){
            // 오른쪽에 만들기
//            let edit = UIContextualAction(style: .normal, title: "edit") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
//                        print("edit")
//                let alert = UIAlertController(title: "카테고리명 입력", message: "수정할 카테고리명을 입력하세요", preferredStyle: .alert)
//
//                        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
//
//                            self.addCategoryname = alert.textFields?[0].text ?? ""
//                            self.categoryList[indexPath.section] = self.addCategoryname
//                            self.categorySet.beginUpdates()
//                            self.categorySet.reloadSections(IndexSet((indexPath.section)...(indexPath.section)), with: UITableView.RowAnimation.automatic)
//                            self.categorySet.endUpdates()
//
//                        }
//
//                        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (cancel) in
//
//                             //code
//
//                        }
//
//                        alert.addAction(cancel)
//
//                        alert.addAction(ok)
//                        alert.addTextField ()
//
//                        self.present(alert, animated: true, completion: nil)
//                        success(true)
//                    }
//                    edit.backgroundColor = UIColor(displayP3Red: 52/255, green: 95/255, blue: 207/255, alpha: 1)
//                    edit.image = UIImage(named: "PencilSquare.png")

                    let delete = UIContextualAction(style: .normal, title: "delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                        if recordArray[indexPath.section].isEmpty == true {
                            self.categoryWillDelete(categoryIdx: indexPath)
                            success(true)
                        } else {
                            let alert = UIAlertController(title: "기록이 1개 이상 저장되어 있는 카테고리는 삭제할 수 없습니다.", message: "", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "ok", style: .default)
                            alert.addAction(okAction)

                            //alert 실행
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
            delete.backgroundColor = UIColor(displayP3Red: 194/255, green: 62/255, blue: 62/255, alpha: 1)
                delete.image = UIImage(named: "Trash.png")
                    //actions배열 인덱스 0이 왼쪽에 붙어서 나옴
                    return UISwipeActionsConfiguration(actions:[delete])
        }else {return UISwipeActionsConfiguration(actions:[])}
        
    }
    
    func categoryWillDelete(categoryIdx:IndexPath) {
        let alert = UIAlertController(title: nil, message: "이 카테고리를 삭제하시겠습니까?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (_) in
            if CoreDataFunc.deleteCategory(categoryIdx: categoryIdx) {
                categoryArray1.remove(at: categoryIdx.section)
                self.categorySet.deleteSections(IndexSet(integer: categoryIdx.section), with: .fade)
                
            }
            
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

