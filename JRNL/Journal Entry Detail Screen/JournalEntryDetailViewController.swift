//
//  JournalEntryDetailViewController.swift
//  JRNL
//
//  Created by 🇭🇰Ry Wong on 28/03/2024.
//

import MapKit
import UIKit

class JournalEntryDetailViewController: UITableViewController {
    // MARK: - Properties

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var ratingView: RatingView!
    var selectedJournalEntry: JournalEntry?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateLabel.text = self.selectedJournalEntry?.dateString
        self.ratingView.rating = self.selectedJournalEntry?.rating ?? 0
        self.titleLabel.text = self.selectedJournalEntry?.entryTitle
        self.bodyTextView.text = self.selectedJournalEntry?.entryBody
        if let photoData = selectedJournalEntry?.photoData {
            self.photoImageView.image = UIImage(
                data: photoData
            )
        }
        self.getMapSnapshot()
    }

    // MARK: - private methods

    private func getMapSnapshot() {
        if let lat = selectedJournalEntry?.latitude, let long = selectedJournalEntry?.longitude {
            let options = MKMapSnapshotter.Options()
            options.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: lat,
                    longitude: long
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )

            options.size = CGSize(
                width: 300,
                height: 300
            )

            options.preferredConfiguration = MKStandardMapConfiguration()

            let snapShotter = MKMapSnapshotter(
                options: options
            )
            snapShotter.start {
                snapShot,
                    error in
                if let snapShot = snapShot {
                    self.mapImageView.image = snapShot.image
                } else if let error = error {
                    print(
                        "snapShot error: \(error.localizedDescription)"
                    )
                }
            }
        } else {
            self.mapImageView.image = nil
        }
    }
}
