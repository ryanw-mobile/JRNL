//
//  JournalListCollectionViewCell.swift
//  JRNL
//
//  Created by Ryan Wong on 28/03/2024.
//

import UIKit

class JournalListCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.hoverStyle =
            .init(effect: .highlight, shape: .rect(cornerRadius: 8.0))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.hoverStyle = .init(effect: .highlight, shape: .rect(cornerRadius: 8.0))
    }
}
