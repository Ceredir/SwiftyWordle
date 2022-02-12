//
//  LetterCollectionViewCell.swift
//  SwiftyWordle
//
//  Created by Ceredir on 10/02/2022.
//

import UIKit

class LetterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var letterLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.backgroundColor = .white
        letterLabel.text = ""
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        
        contentView.backgroundColor = .white
        letterLabel.text = ""
    }
    
    func setLetter(_ letter: String, state: WordComparisonResult.LetterState?) {
        letterLabel.text = letter
        if let state = state {
            switch state {
                case .hit: markHit()
                case .exists: markExists()
                case .none: markNone()
            }
        }
    }
    
    private func markHit() {
        contentView.backgroundColor = .green
    }
    
    private func markExists() {
        contentView.backgroundColor = .yellow
    }
    
    private func markNone() {
        contentView.backgroundColor = .systemGray6
    }
}
