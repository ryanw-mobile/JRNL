//
//  SharedData.swift
//  JRNL
//
//  Created by Ryan Wong on 30/03/2024.
//

import UIKit

class SharedData {
    // MARK: - Properties

    static let shared = SharedData()
    private var journalEntries: [JournalEntry]

    // MARK: - Private

    private init() {
        self.journalEntries = []
    }

    // MARK: - Access methods

    func numberOfJournalEntries() -> Int {
        self.journalEntries.count
    }

    func getJournalEntry(
        index: Int
    ) -> JournalEntry {
        self.journalEntries[index]
    }

    func getAllJournalEntries() -> [JournalEntry] {
        let readOnlyJournalEntries = self.journalEntries
        return readOnlyJournalEntries
    }

    func addJournalEntry(
        newJournalEntry: JournalEntry
    ) {
        self.journalEntries.append(
            newJournalEntry
        )
    }

    func removeJournalEntry(
        index: Int
    ) {
        self.journalEntries.remove(
            at: index
        )
    }

    func removeSelectedJournalEntry(_ selectedJournalEntry: JournalEntry) {
        self.journalEntries.removeAll {
            $0.key == selectedJournalEntry.key
        }
    }

    // MARK: - Persistence

    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        return paths[0]
    }

    func loadJournalEntriesData() {
        let pathDirectory = self.getDocumentDirectory()
        let fileURL = pathDirectory.appendingPathComponent(
            "journalEntriesData.json"
        )

        do {
            let data = try Data(
                contentsOf: fileURL
            )
            let journalEntriesData = try JSONDecoder().decode(
                [JournalEntry].self,
                from: data
            )
            self.journalEntries = journalEntriesData
        } catch {
            print(
                "Failed to read JSON data: \(error.localizedDescription)"
            )
        }
    }

    func saveJournalEntriesData() {
        let pathDirectory = self.getDocumentDirectory()
        try? FileManager().createDirectory(
            at: pathDirectory,
            withIntermediateDirectories: true
        )
        let filePath = pathDirectory.appendingPathComponent(
            "journalEntriesData.json"
        )
        let json = try? JSONEncoder().encode(
            self.journalEntries
        )
        do {
            try json!.write(
                to: filePath
            )
        } catch {
            print(
                "Failed to write JSON data: \(error.localizedDescription)"
            )
        }
    }
}
