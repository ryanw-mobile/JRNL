//
//  JRNLWidget.swift
//  JRNLWidget
//
//  Created by Ryan Wong on 01/04/2024.
//  Copyright © 2024 RW MobiMedia. All rights reserved.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), journalEntryDate: "JRNL", journalEntryTitle: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), journalEntryDate: "JRNL", journalEntryTitle: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        var journalEntries: [JournalEntry] = []
        SharedData.shared.loadJournalEntriesData()
        journalEntries = SharedData.shared.getAllJournalEntries()

        for minuteOffset in 0 ..< journalEntries.count {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset * 5, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, journalEntryDate: journalEntries[minuteOffset].dateString, journalEntryTitle: journalEntries[minuteOffset].entryTitle)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var journalEntryDate: String
    var journalEntryTitle: String
}

struct JRNLWidgetEntryView: View {
    var entry: Provider.Entry
    var body: some View {
        VStack {
            AccessoryWidgetBackground()
            VStack {
                Text(self.entry.journalEntryDate).font(.headline)
                Text(self.entry.journalEntryTitle).font(.body)
            }
        }
    }
}

struct JRNLWidget: Widget {
    let kind: String = "JRNLWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: self.kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                JRNLWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                JRNLWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("JRNLWidget")
        .description("This widget displays journal entries.")
        .supportedFamilies([.systemMedium, .accessoryRectangular])
    }
}

#Preview(as: .systemMedium) {
    JRNLWidget()
} timeline: {
    SimpleEntry(date: .now, journalEntryDate: "22 Aug 2024", journalEntryTitle: "Today is a good day")
    SimpleEntry(date: .now, journalEntryDate: "22 Aug 2024", journalEntryTitle: "Today is a bad day")
    SimpleEntry(date: .now, journalEntryDate: "22 Aug 2024", journalEntryTitle: "Today is an OK day")
}

#Preview(as: .accessoryRectangular) {
    JRNLWidget()
} timeline: {
    SimpleEntry(date: .now, journalEntryDate: "22 Aug 2024", journalEntryTitle: "Today is a good day")
    SimpleEntry(date: .now, journalEntryDate: "22 Aug 2024", journalEntryTitle: "Today is a bad day")
    SimpleEntry(date: .now, journalEntryDate: "22 Aug 2024", journalEntryTitle: "Today is an OK day")
}
