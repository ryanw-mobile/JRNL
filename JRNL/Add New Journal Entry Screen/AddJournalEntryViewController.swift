//
//  AddJournalEntryViewController.swift
//  JRNL
//
//  Created by 🇭🇰Ry Wong on 28/03/2024.
//

import CoreLocation
import UIKit

class AddJournalEntryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Properties

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var getLocationSwitch: UISwitch!
    @IBOutlet var getLocationSwitchLabel: UILabel!
    @IBOutlet var ratingView: RatingView!
    var newJournalEntry: JournalEntry?
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self
        self.bodyTextView.delegate = self
        self.updateSaveButtonState()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(
        _ textField: UITextField
    ) {
        self.saveButton.isEnabled = false
    }

    func textFieldDidEndEditing(
        _ textField: UITextField
    ) {
        self.updateSaveButtonState()
    }

    // MARK: - UITextViewDelegate

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if
            text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
    }

    func textViewDidBeginEditing(
        _ textView: UITextView
    ) {
        self.saveButton.isEnabled = false
    }

    func textViewDidEndEditing(
        _ textView: UITextView
    ) {
        self.updateSaveButtonState()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let myCurrentLocation = locations.first {
            self.currentLocation = myCurrentLocation
            self.getLocationSwitchLabel.text = "Done"
            self.updateSaveButtonState()
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

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController
    ) {
        dismiss(
            animated: true
        )
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError(
                "Expected a dictionary containing an image, but was provided the following: \(info)"
            )
        }

        let smallerImage = selectedImage.preparingThumbnail(
            of: CGSize(
                width: 300,
                height: 300
            )
        )
        self.photoImageView.image = smallerImage

        dismiss(
            animated: true
        )
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let title = self.titleTextField.text ?? ""
        let body = self.bodyTextView.text ?? ""
        let photo = self.photoImageView.image
        let rating = self.ratingView.rating
        let lat = self.currentLocation?.coordinate.latitude
        let long = self.currentLocation?.coordinate.longitude
        self.newJournalEntry = JournalEntry(
            rating: rating,
            title: title,
            body: body,
            photo: photo,
            latitude: lat,
            longitude: long
        )
    }

    // MARK: - Private methods

    private func updateSaveButtonState() {
        let textFieldText = self.titleTextField.text ?? ""
        let textViewText = self.bodyTextView.text ?? ""
        if self.getLocationSwitch.isOn {
            self.saveButton.isEnabled = !textFieldText.isEmpty && !textViewText.isEmpty && !(
                self.currentLocation == nil
            )
        } else {
            self.saveButton.isEnabled = !textFieldText.isEmpty && !textViewText.isEmpty
        }
    }

    // MARK: - Actions

    @IBAction func getLocationSwitchValueChanged(
        _ sender: UISwitch
    ) {
        if self.getLocationSwitch.isOn {
            self.getLocationSwitchLabel.text = "Getting location..."
            self.locationManager.requestLocation()
        } else {
            self.currentLocation = nil
            self.getLocationSwitchLabel.text = "Get location"
        }
    }

    @IBAction func getPhoto(
        _ sender: UITapGestureRecognizer
    ) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        #if targetEnvironment(simulator)
            imagePickerController.sourceType = .photoLibrary
        #else
            imagePickerController.sourceType = .camera
            imagePickerController.showsCameraControls = true
        #endif
        present(
            imagePickerController,
            animated: true
        )
    }
}
