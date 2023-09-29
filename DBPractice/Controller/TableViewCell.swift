//
//  TableViewCell.swift
//  DBPractice
//
//  Created by Marcos on 25/9/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    @IBOutlet weak var characterNameLabel: UILabel!
    
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }
    
    func configure(with representable: any TableViewRepresentable) {
        characterNameLabel.text = representable.name
        descriptionLabel.text = representable.description
        imagenView.setImage(for: representable.photo)
    }
    
}

protocol TableViewRepresentable {
    var id: String {get}
    var name: String { get }
    var description: String {get}
    var photo: URL {get}

}
