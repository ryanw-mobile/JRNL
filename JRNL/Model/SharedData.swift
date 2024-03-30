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
    
    // MARK: - Persistence
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        return paths[0]
    }
    
    func loadJournalEntriesData() {
        let pathDirectory = getDocumentDirectory()
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
            journalEntries = journalEntriesData
        } catch {
            print(
                "Failed to read JSON data: \(error.localizedDescription)"
            )
        }
    }
    
    func saveJournalEntriesData() {
        let pathDirectory = getDocumentDirectory()
        try? FileManager().createDirectory(
            at: pathDirectory,
            withIntermediateDirectories: true
        )
        let filePath = pathDirectory.appendingPathComponent(
            "journalEntriesData.json"
        )
        let json = try? JSONEncoder().encode(
            journalEntries
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
