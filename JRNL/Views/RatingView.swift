//
//  RatingView.swift
//  JRNL
//
//  Created by 🇭🇰Ry Wong on 31/03/2024.
//

import UIKit

class RatingView: UIStackView {
    // MARK: - Properties

    private var ratingButtons = [UIButton()]
    var rating = 0 {
        didSet {
            self.updateButtonSelectionStates()
        }
    }

    private let buttonSize = CGSize(
        width: 44.0,
        height: 44.0
    )
    private let buttonCount = 5

    // MARK: - Initialization

    required init(
        coder: NSCoder
    ) {
        super.init(
            coder: coder
        )
        self.setupButtons()
    }

    // MARK: - Action

    @objc func ratingButtonTapped(
        button: UIButton
    ) {
        guard let index = ratingButtons.firstIndex(
            of: button
        ) else {
            fatalError(
                "The button, \(button), is not in the ratingButtons array: \(self.ratingButtons)"
            )
        }

        let selectedRating = index + 1
        if selectedRating == self.rating {
            self.rating = 0
        } else {
            self.rating = selectedRating
        }
    }

    // MARK: - Private methods

    private func setupButtons() {
        for button in self.ratingButtons {
            removeArrangedSubview(
                button
            )
            button.removeFromSuperview()
        }

        self.ratingButtons.removeAll()
        let filledStar = UIImage(
            systemName: "star.fill"
        )
        let emptyStar = UIImage(
            systemName: "star"
        )
        let highlightedStar = UIImage(
            systemName: "star.fill"
        )?.withTintColor(
            .red,
            renderingMode: .alwaysOriginal
        )

        for _ in 0 ..< self.buttonCount {
            let button = UIButton()
            button.setImage(
                emptyStar,
                for: .normal
            )
            button.setImage(
                filledStar,
                for: .selected
            )
            button.setImage(
                highlightedStar,
                for: .highlighted
            )
            button.setImage(
                highlightedStar,
                for: [
                    .highlighted,
                    .selected,
                ]
            )

            button.translatesAutoresizingMaskIntoConstraints = false

            button.heightAnchor.constraint(
                equalToConstant: self.buttonSize.height
            )
            .isActive = true
            button.widthAnchor.constraint(
                equalToConstant: self.buttonSize.width
            )
            .isActive = true

            button.addTarget(
                self,
                action: #selector(
                    RatingView.ratingButtonTapped(
                        button:
                    )
                ),
                for: .touchUpInside
            )

            addArrangedSubview(
                button
            )
            self.ratingButtons.append(
                button
            )
        }
    }

    private func updateButtonSelectionStates() {
        for (index, button) in self.ratingButtons.enumerated() {
            button.isSelected = index < self.rating
        }
    }
}
