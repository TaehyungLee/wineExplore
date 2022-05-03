//
//  ViewController.swift
//  WineExplore
//
//  Created by Taehyung Lee on 2022/05/02.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var wineListTableView:UITableView!
    
    var wineList:[WineDataModel] = []
    
    let db = Database.database().reference()
    
    let myIdStr = "thlee01"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 개인 고유의 번호 필요
        
        test()
    }
    
    // 와인 데이터 저장하기
    func saveWineData(_ data:WineDataModel) {
        self.db.child("wines").child(self.myIdStr).setValue(["name": data.name,
                                                             "imageUrlStr": data.imageUrlStr,
                                                             "serial_no": data.serial_no,
                                                             "price": data.price,
                                                             "content": data.content
                                                            ])
    }
    
    // 와인 데이터 가져오기
    func getWineData(_ s_no:String) -> WineDataModel {
        
        var data:WineDataModel = WineDataModel()
        self.db.child("wines").child(self.myIdStr).observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let imageUrlStr = value?["imageUrlStr"] as? String ?? ""
            let serial_no = value?["serial_no"] as? String ?? ""
            let price = value?["price"] as? Int ?? 0
            let content = value?["content"] as? String ?? ""
            data = WineDataModel(name: name, serial_no: serial_no, imageUrlStr: imageUrlStr, price: price, content: content)

        }) { error in
            print(error.localizedDescription)
        }
        
        return data
        
    }
    
    func updateWineData(_ data:WineDataModel) {
//        guard let key = self.db.child("wines").childByAutoId().key else { return }
//        let wineData:[String:Any] = ["name": data.name,
//                                     "imageUrlStr": data.imageUrlStr,
//                                     "serial_no": data.serial_no,
//                                     "price": data.price,
//                                     "content": data.content]
//        let childUpdates = ["/wines/\(key)": wineData,
//                            "/user-posts/\(userID)/\(key)/": wineData]
//        self.db.updateChildValues(childUpdates)
    }

    func test() {
        db.child("wineName").observeSingleEvent(of: .value) {snapshot in
                    print("---> \(snapshot)")
                    let value = snapshot.value as? String ?? "" //2번째 줄
                    DispatchQueue.main.async {
                        self.wineList.append(WineDataModel(name: value, serial_no: "11", imageUrlStr: "name_url", price: 54000, content: "wine test---"))
                        self.wineListTableView.reloadData()
                    }
                }
    }
    // wine data 요청
    
    
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wineList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WineDataCell", for: indexPath) as! WineDataCell
        
        let windData = self.wineList[indexPath.row]
        
        cell.nameLabel.text = windData.name
        
        return cell
        
    }
}
