//
//  ViewController.swift
//  OnePieceApp
//
//  Created by Atila Bastos on 24/06/21.
//

import UIKit

class OPAViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var opaManager = OPAManager()
    
    let searchController = UISearchController()
    
    // Creating only one cell I don't need to initialize the array with a lot of strings.
    var chapterInformation: [OPAModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        opaManager.delegate = self
        
        setupSearchBar()
        
    }
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
    }
    
}

//MARK: - UITextFieldDelegate

extension OPAViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        // Making the array empty when another request been made.
        chapterInformation = []
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "You must type a chapter number"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let chapter = searchTextField.text {
            opaManager.getChapterNumber(for: chapter)
        }
        
        searchTextField.text = ""
    }
    
}

//MARK: - OPAManagerDelegate

extension OPAViewController: OPAManagerDelegate {
    
    func didUpdateChapter(_ opaManager: OPAManager, chapterNumberInfo: OPAModel) {
        
        // Storing the chapter info from the delegate method on a constant and putting it inside the array
        let newChapterInfo = OPAModel(chapter: chapterNumberInfo.chapter, title: chapterNumberInfo.title, summary: chapterNumberInfo.summary, characters: chapterNumberInfo.characters)
        
        self.chapterInformation.append(newChapterInfo)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    
    func didFailWithError(_ opaManager: OPAManager, error: Error) {
        print(error)
    }
    
}

//MARK: - UITableViewDataSource

extension OPAViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returning the number of cells based on how many items are inside the array
        return chapterInformation.count
    }
    
    // Not obrigatory method, but helps to separate the topics using the tableview sections
    // This method could be a solution when I have the case with one row inside the array containing various informations, creating more sections instead of more cells.
    func numberOfSections(in tableView: UITableView) -> Int {
        // One section for each information that I'm returning from the API
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        // Showing for each section one information from the chapter
        // The array will only contain one OPAModel object, with the necessary information, that's why I'm using only the first row from the array and split the information from this row at the 4 rows at my tableview
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = chapterInformation[0].chapter
        case 1:
            cell.textLabel?.text = chapterInformation[0].title
        case 2:
            cell.textLabel?.text = chapterInformation[0].summary
            // numberOfLines = 0 is used to not limitate the cell's size. Using it will make the cell not truncate the letters.
            cell.textLabel?.numberOfLines = 0
        case 3:
            cell.textLabel?.text = chapterInformation[0].characters
            cell.textLabel?.numberOfLines = 0
        default:
            print("No info registered")
        }
        
        // Adjusting the cell's alpha to make the background appear.
        cell.backgroundColor = .init(white: 1.0, alpha: 0.5)
        
        return cell
    }
    
    // Another DataSource not obrigathory method, this one will create the 4 sections that I need to split the information brought by the OPADelegate method
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Switch case to name the topics
        switch section {
        case 0:
            return "Chapter"
        case 1:
            return "Title"
        case 2:
            return "Summary"
        case 3:
            return "Characters"
        default:
            return nil
        }
    }
}

//MARK: - UITableViewDelegate

extension OPAViewController: UITableViewDelegate {
    // Method used to automatic adjust the tableview cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: - UISearchBarDelegate

extension OPAViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        chapterInformation = []
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text != "" {
            return true
        } else {
            searchBar.placeholder = "You must type a chapter number"
            return false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let chapter = searchBar.text {
            opaManager.getChapterNumber(for: chapter)
        }
        
        searchBar.text = ""
    }
    
}
