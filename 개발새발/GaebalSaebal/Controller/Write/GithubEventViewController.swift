//
//  GithubRepoViewController.swift
//  GaebalSaebal
//
//  Created by DOYEONLEE2 on 2022/05/16.
//

import UIKit

protocol SendSelectedGithubEventDelegate{
    func sendGithubEvent(event: Event,
                         selectedRepoOwner: String,
                         selectedRepoName: String)
}

// MARK: - ✅ Structure
public struct Issues: Codable {
    public let number: Int
    public let title: String
    public let node_id: String
    public let created_at: String
}

public struct PullRequests: Codable {
    public let number: Int
    public let title: String
    public let node_id: String
    public let created_at: String
}
public struct Commits: Codable {
    public let commit: Commit
    public let sha: String
    public let node_id: String
}
public struct Commit: Codable {
    public let author: Author
    public let message: String
}

public struct Author: Codable {
    public let date: String
}

public struct Event{
    public let type: String
    // 커밋 번호에 영문이 포함되므로 number string으로 변경
    public let number: String
    public let title: String
    public let node_id: String
    public let created_at: String
}

class GithubEventViewController: UIViewController{
    // MARK: - ✅ IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ✅ Variables
    
    //날짜 데이터 sort
    let testArray = ["2022-04-16T06:20:31Z",
                     "2022-04-16T19:20:31Z",
                     "2022-05-16T06:20:31Z",
                     "2022-05-02T05:40:31Z" ]
    var convertedArray: [Date] = []

    //API
    var userIssues: [Issues] = []
    var userPRs: [PullRequests] = []
    var userCommits: [Commits] = []
    var userEvents: [Event] = []
    

    //깃허브
    var selectedRepoOwner = ""
    var selectedRepoName = ""
    var selectedEvent: Event = Event(type: "", number: "", title: "", node_id: "", created_at: "")
    let auth = "Token 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"
    
    // 화면 사라질 때 정보 보내려구,,
    var delegate: SendSelectedGithubEventDelegate?
    
    // 화면 넓이 바인딩
    var originViewWidth: CGFloat = 0.0
    

    // MARK: - ✅ View Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        DispatchQueue.main.async { [self] in
            print("### main view frame width : \(self.view.frame.width)")
            self.originViewWidth = self.view.frame.width
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.clear
        
        print("###\(self.selectedRepoName)")
        print("###\(self.selectedRepoOwner)")
        

        getIssues(gitID: self.selectedRepoOwner, repo: self.selectedRepoName)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        print("ViewController의 view가 사라짐")

    }
    
    // MARK: - ✅ Custom Function
    
    func changeDateFormat(dateStr: String) -> String{

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" // 2020-08-13 16:30
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
                
        let convertDate = dateFormatter.date(from: dateStr) // Date 타입으로 변환
                
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy.MM.dd a hh:mm" // 2020.08.13 오후 04시 30분
        myDateFormatter.locale = Locale(identifier: Locale.current.identifier)
        let convertStr = myDateFormatter.string(from: convertDate!)
        
        return convertStr
    }

    

}

// MARK: - ✅ Talble View Funcion

extension GithubEventViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    //섹션 간격
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "githubEventCell", for: indexPath)
        
        if let cell = cell as? GithubEventTableViewCell {
            
            cell.originContentWidth = self.originViewWidth
            
            let greenLabelColor = UIColor.init(red: 77/255, green: 168/255, blue: 86/255, alpha: 1)
            let blueLabelColor = UIColor.init(red: 48/255, green: 141/255, blue: 181/255, alpha: 1)
            let redLabelColor = UIColor.init(red: 185/255, green: 54/255, blue: 54/255, alpha: 1)
            
            var labelColor:UIColor = UIColor()
            
            // type 라벨 설정 (이슈인지, 풀인지, 커밋인지)
            switch ( userEvents[indexPath.section].type){
            case "issue":
                cell.typeLabel.text = "    issue    "
                labelColor = redLabelColor
            case "pull request":
                cell.typeLabel.text = "    pull requeset    "
                labelColor = blueLabelColor
                
            default:
                cell.typeLabel.text = "    commit    "
                labelColor = greenLabelColor
            }
            
            // 라벨 컬러 변경
            cell.typeLabel.layer.borderColor = labelColor.cgColor
            cell.typeLabel.textColor = labelColor

            
            // 셀 내용 변경
            cell.titleLabel.text = userEvents[indexPath.section].title
            cell.dateLabel.text = changeDateFormat(dateStr: userEvents[indexPath.section].created_at)
            cell.repoNameLabel.text = self.selectedRepoName
            
            // 선택 시 아무 애니메이션 X
            cell.selectionStyle = .none
            
            
  
        }
        

        
        return cell
    }
    
    // 터치 이벤트
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedEvent = userEvents[indexPath.section]
        self.delegate?.sendGithubEvent(event: userEvents[indexPath.section],
                                       selectedRepoOwner: self.selectedRepoOwner,
                                       selectedRepoName: self.selectedRepoName)
        
//        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)

        delegate?.sendGithubEvent(event: selectedEvent,
                                  selectedRepoOwner: selectedRepoOwner,
                                  selectedRepoName: selectedRepoName)

    }

    
}

// MARK: -  ✅ API

extension GithubEventViewController  {

    
    func getIssues(gitID:String, repo:String) {


//        let auth = "Token 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"

        let baseURL = "https://api.github.com/repos"
        let urlString = baseURL + "/" + gitID + "/" + repo + "/issues?state=all&page=1&per_page=15"
        
        if let url = URL(string: urlString) {
            var requestURL = URLRequest(url: url)
            requestURL.addValue(auth, forHTTPHeaderField: "Authorization")
            requestURL.httpMethod = "GET"
            requestURL.allHTTPHeaderFields = ["Content-Type":"application/json"]
            let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
                if let data = data {
                    let jsonData = try? JSONDecoder().decode([Issues].self, from: data)
                    guard let rsData = jsonData else {
                        print("이슈 불러오기 오류발생")
                        return
                    }
                    // call back
                    for rsItem in rsData {
                        if rsItem.node_id.starts(with: "I") {
                            self.userIssues.append(rsItem)
                        }
                    }
                    self.getPRs(gitID: gitID, repo: repo)
                }
            }
            dataTask.resume()
        }
    }

    func getPRs(gitID:String, repo:String){

        

//        let auth = "Token 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"

        let baseURL = "https://api.github.com/repos"
        let urlString = baseURL + "/" + gitID + "/" + repo + "/pulls?state=all&page=1&per_page=10"
        if let url = URL(string: urlString) {
            var requestURL = URLRequest(url: url)
            requestURL.addValue(auth, forHTTPHeaderField: "Authorization")
            requestURL.httpMethod = "GET"
            requestURL.allHTTPHeaderFields = ["Content-Type":"application/json"]
            let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
                if let data = data {
                    let jsonData = try? JSONDecoder().decode([PullRequests].self, from: data)
                    guard let rsData = jsonData else {
                        print("PR 불러오기 오류발생")
                        return
                    }
                    //call back
                    for rsItem in rsData {
                        self.userPRs.append(rsItem)
                    }
                    self.getCommits(gitID: gitID, repo: repo)
                }
            }
            dataTask.resume()
        }
    }

    func getCommits(gitID:String, repo:String){

     

//        let auth = "Token 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"

        let baseURL = "https://api.github.com/repos"
        let urlString = baseURL + "/" + gitID + "/" + repo + "/commits?page=1&per_page=10"
        if let url = URL(string: urlString) {
            var requestURL = URLRequest(url: url)
            requestURL.addValue(auth, forHTTPHeaderField: "Authorization")
            requestURL.httpMethod = "GET"
            requestURL.allHTTPHeaderFields = ["Content-Type":"application/json"]
            let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
                if let data = data {
                    let jsonData = try? JSONDecoder().decode([Commits].self, from: data)
                    guard let rsData = jsonData else {
                        print("commit 불러오기 오류발생")
                        return
                    }
                    for rsItem in rsData {
                        self.userCommits.append(rsItem)
                    }
                    self.combineAllEvents()
                }
            }
            dataTask.resume()
        }
    }
    
    func combineAllEvents(){
        // issue 통합!
        self.userIssues.forEach{
            let tempEvent:Event = Event(type: "issue",
                                        number: String($0.number),
                                        title: $0.title,
                                        node_id: $0.node_id,
                                        created_at: $0.created_at
                                        )
            userEvents.append(tempEvent)
        }
        
        // pull request 통합
        self.userPRs.forEach{
            let tempEvent:Event = Event(type: "pull request",
                                        number:String($0.number),
                                        title: $0.title,
                                        node_id: $0.node_id,
                                        created_at: $0.created_at
                                        )
            userEvents.append(tempEvent)
        }
        
        // commit 통합
        self.userCommits.forEach{
            
            let str = $0.sha
            let startIndex = str.index(str.startIndex, offsetBy: 0)// 사용자지정 시작인덱스
            let endIndex = str.index(str.startIndex, offsetBy: 7)// 사용자지정 끝인덱스
            let sliced_str = str[startIndex ..< endIndex]
            let commitNumber:String = String(sliced_str)
            
            let tempEvent:Event = Event(type: "commit",
                                        number: commitNumber,
                                        title: $0.commit.message,
                                        node_id: $0.node_id,
                                        created_at: $0.commit.author.date
                                        )
            userEvents.append(tempEvent)
        }
        
        reformDateFormat()

    }
    
    func reformDateFormat(){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"// yyyy-MM-dd
//
//        for event in self.userEvents {
//            let targetDate = event.created_at
//            let date = dateFormatter.date(from: targetDate)
//            if let date = date {
//                event.date = date
//            }
//        }

        self.userEvents = self.userEvents.sorted(by: { $0.created_at.compare($1.created_at) == .orderedDescending })
        
        
        self.userEvents.forEach{
            print( $0 )
        }
        
        DispatchQueue.main.sync{
            self.tableView.reloadData()
        }
    }
    
    

}
