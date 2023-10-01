//
//  ListViewViewController.swift
//  DBPractice
//
//  Created by Marcos on 18/9/23.
//

import UIKit

class ListViewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
  
    
    private let characters: [TableViewRepresentable]
    
    init(characters: [TableViewRepresentable], title: String) {
        self.characters = characters
      //  self.characters = characters.sorted(by: { $0.name < $1.name})
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//     Mocked data
//    private let characters: [Hero] = [Hero(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
//        name: "Goku",
//        description: "Sobran las presentaciones cuando se habla de Goku.",
//        photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300")!,
//        favorite: false)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = "Personajes"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        //Si quiero una custom
        //tableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
    
    }
}

// MARK: - Table View Datasource

extension ListViewViewController: UITableViewDataSource {
    
    func tableView(_ tablewView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = UITableViewCell()
       // let character = characters[indexPath.row]
       // cell.textLabel?.text = character
       // cell.accessoryType = .disclosureIndicator
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let character = characters[indexPath.row]
        cell.configure(with: character as TableViewRepresentable)
        return cell
    }
    
}

// MARK: DELEGATE

extension ListViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        
        let model = NetworkModel()
        model.getTransformations(for: character) {
            result in
            switch result {
            case let .success(transformations):
                DispatchQueue.main.async {
                    let detailViewController = DetailViewController(character: character, transformations: transformations, title: character.name)
                    self.navigationController?.show(detailViewController, sender: nil)
                }
            case let .failure(error):
                print("Error -> \(error)")
            }
        }

        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
