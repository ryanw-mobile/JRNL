//
//  JournalListViewController.swift
//  JRNL
//
//  Created by 🇭🇰Ry Wong on 19/03/2024.
//

import UIKit

class JournalListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedData.shared.loadJournalEntriesData()
    }

    // MARK: - UITableViewDataSource

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        SharedData.shared.numberOfJournalEntries()
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let journalCell = tableView.dequeueReusableCell(
            withIdentifier: "journalCell",
            for: indexPath
        ) as! JournalListTableViewCell
        let journalEntry = SharedData.shared.getJournalEntry(
            index: indexPath.row
        )
        
        if let photoData = journalEntry.photoData {
            journalCell.photoImageView.image = UIImage(
                data: photoData
            )
        }
        journalCell.dateLabel.text = journalEntry.dateString
        journalCell.titleLabel.text = journalEntry.entryTitle
        return journalCell
    }

    // MARK: - UITableViewDelegate

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            SharedData.shared.removeJournalEntry(
                index: indexPath.row
            )
            SharedData.shared.saveJournalEntriesData()
            tableView.reloadData()
        }
    }

    // MARK: - Methods

    @IBAction func unwindNewEntryCancel(
        segue: UIStoryboardSegue
    ) {}

    @IBAction func unwindNewEntrySave(
        segue: UIStoryboardSegue
    ) {
        if let sourceViewController = segue.source as? AddJournalEntryViewController,
           let newJournalEntry = sourceViewController.newJournalEntry
        {
            SharedData.shared.addJournalEntry(
                newJournalEntry: newJournalEntry
            )
            SharedData.shared.saveJournalEntriesData()
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        super.prepare(
            for: segue,
            sender: sender
        )
        guard segue.identifier == "entryDetail" else {
            return
        }

        guard let journalEntryDetailViewController = segue.destination as? JournalEntryDetailViewController,
              let selectedJournalEntryCell = sender as? JournalListTableViewCell,
              let indexPath = tableView.indexPath(
                  for: selectedJournalEntryCell
              )
        else {
            fatalError(
                "Could not get indexPath"
            )
        }
        let selectedJournalEntry = SharedData.shared.getJournalEntry(
            index: indexPath.row
        )
        journalEntryDetailViewController.selectedJournalEntry = selectedJournalEntry
    }
}
