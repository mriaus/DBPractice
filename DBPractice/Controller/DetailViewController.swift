//
//  DetailViewController.swift
//  DBPractice
//
//  Created by Marcos on 25/9/23.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var transformationsButton: UIButton!
    
    private let character: TableViewRepresentable
    private let transformations: [TableViewRepresentable]
    
    init(character: TableViewRepresentable, transformations: [TableViewRepresentable]) {
        self.character = character
        self.transformations = transformations
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Block the enter in that method from all the versions (* All the versions ) to (unavailable)
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterNameLabel.text = character.name
        descriptionText.text = character.description
        descriptionText.isEditable = false
        imageView.setImage(for: character.photo)
        self.transformationsButton.isHidden = transformations.isEmpty

        // Do any additional setup after loading the view.
    }


    @IBAction func onPressTransformations(_ sender: UIButton) {
       let listViewViewController = ListViewViewController(characters: transformations )
//     Push the second view controller onto the navigation stack
        DispatchQueue.main.async {
            self.navigationController?.show(listViewViewController, sender: nil)
        }
    }
    

}
