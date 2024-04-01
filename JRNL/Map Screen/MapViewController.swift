//
//  MapViewController.swift
//  JRNL
//
//  Created by Ryan Wong on 28/03/2024.
//

import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    // MARK: - Properties

    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var selectedJournalEntry: JournalEntry?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.navigationItem.title = "Loading..."
        self.mapView.delegate = self
    }

    override func viewIsAppearing(
        _ animated: Bool
    ) {
        super.viewIsAppearing(
            animated
        )
        self.locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let myCurrentLocation = locations.first {
            let lat = myCurrentLocation.coordinate.latitude
            let long = myCurrentLocation.coordinate.longitude
            self.navigationItem.title = "Map"
            self.mapView.region = self.setInitialRegion(
                lat: lat,
                long: long
            )
            self.mapView.addAnnotations(
                SharedData.shared.getAllJournalEntries()
            )
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(
            "Failed to find user's location: \(error.localizedDescription)"
        )
    }

    // MARK: - MKMapViewDelegate

    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        let identifier = "mapAnnotation"
        if annotation is JournalEntry {
            if let annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: identifier
            ) {
                annotationView.annotation = annotation
                return annotationView
            } else {
                let annotationView = MKMarkerAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier
                )
                annotationView.canShowCallout = true

                let calloutButton = UIButton(
                    type: .detailDisclosure
                )
                annotationView.rightCalloutAccessoryView = calloutButton

                return annotationView
            }
        }
        return nil
    }

    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let annotation = mapView.selectedAnnotations.first
        else {
            return
        }

        self.selectedJournalEntry = annotation as? JournalEntry
        self.performSegue(
            withIdentifier: "showMapDetail",
            sender: self
        )
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
        guard segue.identifier == "showMapDetail" else {
            fatalError(
                "Unexpected segue identifier"
            )
        }

        guard let entryDetailViewController = segue.destination as?
            JournalEntryDetailViewController
        else {
            fatalError(
                "Unexpected view controller"
            )
        }

        entryDetailViewController.selectedJournalEntry = self.selectedJournalEntry
    }

    // MARK: - Private methods

    func setInitialRegion(
        lat: CLLocationDegrees,
        long: CLLocationDegrees
    ) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: lat,
                longitude: long
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        )
    }
}
