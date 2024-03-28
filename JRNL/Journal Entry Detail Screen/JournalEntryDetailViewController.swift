//
//  JournalEntryDetailTableViewController.swift
//  JRNL
//
//  Created by 🇭🇰Ry Wong on 28/03/2024.
//

import UIKit

class JournalEntryDetailViewController: UITableViewController {
    // MARK: - Properties
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

  

}
