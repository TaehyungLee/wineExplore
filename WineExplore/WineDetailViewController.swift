//
//  WineDetailViewController.swift
//  WineExplore
//
//  Created by Taehyung Lee on 2022/05/03.
//

import UIKit
import SPIndicator

class WineDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBackBtn(_ sender:UIButton?) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func onSendBtn(_ sender:UIButton?) {
        SPIndicator.present(title: "Complete", message: "Done", preset: .done)
    }

}
