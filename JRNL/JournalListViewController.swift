//
//  JournalListViewController.swift
//  JRNL
//
//  Created by 🇭🇰Ry Wong on 19/03/2024.
//

import UIKit

class JournalListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView
            .dequeueReusableCell(withIdentifier: "journalCell", for: indexPath)
    }
        
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
