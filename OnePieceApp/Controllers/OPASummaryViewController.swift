//
//  OPASummaryViewController.swift
//  OnePieceApp
//
//  Created by Atila Bastos on 20/08/21.
//

import UIKit

class OPASummaryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chapterRequested: OPAModel?
    
    // Creating only one cell I don't need to initialize the array with a lot of strings.
    var chapterInformation: [OPAModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadChapter()
    }
    
    func loadChapter() {
        if chapterRequested != nil {
            chapterInformation.append(chapterRequested ?? OPAModel(chapter: "", title: "", summary: "", characters: ""))
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - UITableViewDataSource

extension OPASummaryViewController: UITableViewDataSource {
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

extension OPASummaryViewController: UITableViewDelegate {
    // Method used to automatic adjust the tableview cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
