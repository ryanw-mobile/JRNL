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
    var selectedJournalEntry: JournalEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = selectedJournalEntry?.date.formatted(
            .dateTime.day().month(.wide).year()
        )
        titleLabel.text = selectedJournalEntry?.entryTitle
        bodyTextView.text = selectedJournalEntry?.entryBody
        photoImageView.image = selectedJournalEntry?.photo
    }
}
