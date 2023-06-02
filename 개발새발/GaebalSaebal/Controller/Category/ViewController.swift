//
//  CategoryCollectionViewCell.swift
//  GaebalSaebal
//
//  Created by 이봄이 on 2022/04/10.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
//    @IBOutlet weak var collectionView: UICollectionView!
    var collectionView: UICollectionView!
    var defaultCategory:[String] = ["미정"]
    var dataSource: [MyCategory] = []
    
    
    lazy var categoryList:[NSManagedObject] = {
        return CoreDataFunc.fetchCategoryList()
    }()
    
    lazy var recordList:[NSManagedObject] = {
        return CoreDataFunc.fetchRecordList()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultCategory()
        setupWriteButton()
        configure()
        
        setupBackbutton()
        
        CoreDataFunc.setupCategoryData(categoryList: categoryList)
        CoreDataFunc.setupRecordData(recordList: recordList)
        setupDataSource()
//        print("*******************\(recordList[1].value(forKey: "body"))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryList = CoreDataFunc.fetchCategoryList()
        recordList = CoreDataFunc.fetchRecordList()
        DispatchQueue.main.async {
            CoreDataFunc.setupRecordData(recordList: self.recordList)
            self.setupDataSource()
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - 기록 작성 버튼
    func setupWriteButton() {
        navigationItem.largeTitleDisplayMode = .always
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
    
    @objc func tapWriteButton(sender:UIGestureRecognizer) {
            //클릭시 실행할 동작
          performSegue(withIdentifier: "showWriteView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWriteView" {
            let nextVC : WriteViewController = segue.destination as! WriteViewController
            nextVC.writeORedit = false
        }
    }
    
    
    //앱 최초 실행 시 기본 카테고리("기본") 설정
    private func setupDefaultCategory() {
        // save core data
        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = container.viewContext
        let defaultCategory = NSEntityDescription.entity(forEntityName: "Category", in: context)

        if let defaultCategory = defaultCategory {
            if categoryList.isEmpty {
                let start = NSManagedObject(entity: defaultCategory, insertInto: context)
                start.setValue("기본", forKey: "categoryName")
            }
        }

        do {
            try context.save()
            print("기본 카테고리 설정 완료")
        } catch {
            print("Error saving contet \(error)")
        }
    }
    
    //MARK: - CollectionView 설정
    private func configure() {
        let collectionViewLayout = MyLayout()
        collectionViewLayout.delegate = self
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
//        collectionView.layer.borderWidth = 1
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 0, bottom: 10, right: 0)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 700).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
    }
    
    private func setupDataSource() {
        dataSource = MyCategory.getMock()
//        print("hey~\(dataSource)")
    }
    
    private func setupBackbutton() {
        let backbutton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backbutton
    }

}

extension ViewController: MyCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath.item].contentHeightSize
    }
}

//MARK: - Category Collection View data
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath) as! CategoryCollectionViewCell
        if let cell = cell as? CategoryCollectionViewCell {
            cell.myCategory = dataSource[indexPath.item]
            print("check")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryDetailView") as? CategoryDetailViewController else {
            return
        }
        vc.categoryIndex = indexPath.row
        vc.modalPresentationStyle = .fullScreen
        self.navigationController!.pushViewController(vc, animated: false)
    }
    
    
    
}
