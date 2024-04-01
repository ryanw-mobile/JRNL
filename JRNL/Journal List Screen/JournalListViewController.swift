//
//  JournalListViewController.swift
//  JRNL
//
//  Created by 🇭🇰Ry Wong on 19/03/2024.
//

import UIKit

class JournalListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {
    // MARK: - Properties

    @IBOutlet var collectionView: UICollectionView!
    let search = UISearchController(
        searchResultsController: nil
    )
    var filteredTableData: [JournalEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        SharedData.shared.loadJournalEntriesData()
        self.setupCollectionView()
        self.search.searchResultsUpdater = self
        self.search.obscuresBackgroundDuringPresentation = false
        self.search.searchBar.placeholder = "Search titles"
        navigationItem.searchController = self.search
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.search.isActive {
            return self.filteredTableData.count
        } else {
            return SharedData.shared.numberOfJournalEntries()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let journalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "journalCell", for: indexPath) as! JournalListCollectionViewCell
        let journalEntry: JournalEntry
        if self.search.isActive {
            journalEntry = self.filteredTableData[indexPath.row]
        } else {
            journalEntry = SharedData.shared.getJournalEntry(
                index: indexPath.row
            )
        }

        if let photoData = journalEntry.photoData {
            journalCell.photoImageView.image = UIImage(
                data: photoData
            )
        }
        journalCell.dateLabel.text = journalEntry.dateString
        journalCell.titleLabel.text = journalEntry.entryTitle
        return journalCell
    }

    // MARK: - UICollectionView delete method

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {
            _ -> UIMenu? in
            let delete = UIAction(title: "Delete") {
                _ in
                if self.search.isActive {
                    let selectedJournalEntry = self.filteredTableData[indexPath.row]
                    self.filteredTableData.remove(at: indexPath.row)
                    SharedData.shared.removeSelectedJournalEntry(selectedJournalEntry)
                } else {
                    SharedData.shared.removeJournalEntry(
                        index: indexPath.row
                    )
                }
                SharedData.shared.saveJournalEntriesData()
                self.collectionView.reloadData()
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [delete])
        }
        return config
    }

    // MARK: - UITableViewDelegate

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            if self.search.isActive {
                let selectedJournalEntry = self.filteredTableData[indexPath.row]
                self.filteredTableData.remove(at: indexPath.row)
                SharedData.shared.removeSelectedJournalEntry(selectedJournalEntry)
            } else {
                SharedData.shared.removeJournalEntry(
                    index: indexPath.row
                )
            }
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
            self.collectionView.reloadData()
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
              let selectedJournalEntryCell = sender as? JournalListCollectionViewCell,
              let indexPath = collectionView.indexPath(
                  for: selectedJournalEntryCell
              )
        else {
            fatalError(
                "Could not get indexPath"
            )
        }

        let selectedJournalEntry: JournalEntry
        if self.search.isActive {
            selectedJournalEntry = self.filteredTableData[indexPath.row]
        } else {
            selectedJournalEntry = SharedData.shared.getJournalEntry(
                index: indexPath.row
            )
        }
        journalEntryDetailViewController.selectedJournalEntry = selectedJournalEntry
    }

    // MARK: - Search

    func updateSearchResults(
        for searchController: UISearchController
    ) {
        guard let searchBarText = searchController.searchBar.text else {
            return
        }

        self.filteredTableData.removeAll()
        for journalEntry in SharedData.shared.getAllJournalEntries() {
            if journalEntry.entryTitle.lowercased().contains(
                searchBarText.lowercased()
            ) {
                self.filteredTableData.append(
                    journalEntry
                )
            }
        }

        self.collectionView.reloadData()
    }

    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        self.collectionView.collectionViewLayout = flowLayout
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: CGFloat
        if traitCollection.horizontalSizeClass == .compact {
            columns = 1
        } else {
            columns = 2
        }

        let viewWidth = collectionView.frame.width
        let inset = 10.0
        let contentWidth = viewWidth - inset * (columns + 1)
        let cellWidth = contentWidth / columns
        let cellHeight = 90.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
