//
//  SharedData.swift
//  JRNL
//
//  Created by 🇭🇰Ry Wong on 30/03/2024.
//

import UIKit
class SharedData {
    // MARK: - Properties
    static let shared = SharedData()
    private var journalEntries: [JournalEntry]
    
    // MARK: - Private
    private init() {
        journalEntries = []
    }
    
    // MARK: - Access methods
    func numberOfJournalEntries() -> Int {
        journalEntries.count
    }
    
    func getJournalEntry(
        index: Int
    ) -> JournalEntry {
        journalEntries[index]
    }
    
    func getAllJournalEntries() -> [JournalEntry] {
        let readOnlyJournalEntries = journalEntries
        return readOnlyJournalEntries
    }
    
    func addJournalEntry(
        newJournalEntry: JournalEntry
    ) {
        journalEntries.append(
            newJournalEntry
        )
    }
    
    func removeJournalEntry(
        index: Int
    ) {
        journalEntries.remove(
            at: index
        )
    }
}
