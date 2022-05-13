//
//  MyPageViewController.swift
//  GaebalSaebal
//
//  Created by 이봄이 on 2022/04/06.
//

import UIKit

class MyPageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    // MARK: - Declaration
    
    @IBOutlet weak var SettingTable: UITableView!
    

    @IBOutlet weak var Celllabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SettingTable.dataSource=self
        SettingTable.delegate=self
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    //테이블 뷰 한 섹션 당 몇개의 셀을 담을 것인지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //각 row에 해당하는 cell을 return
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "mycell")
        if (indexPath.row==0){
            cell.textLabel?.text="카테고리  추가 / 관리"
        }
        else{
            cell.textLabel?.text="깃허브 사용자 설정"
        }
        
       
        
         return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            tableView.deselectRow(at: indexPath, animated: true)

            switch indexPath.row {

            case 0: self.performSegue(withIdentifier: "GoCategory", sender: nil)

            case 1: self.performSegue(withIdentifier: "GoGitadmin", sender: nil)

            default:

                return

            }

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
