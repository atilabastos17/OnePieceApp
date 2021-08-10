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
    
    // Estava dando erro "index out of range no array" ao abrir o app, por isso inicializei o array com strings vazias ao invés de inicializar com o array vazio
    var chapterInformation = [OPAModel(chapter: "Chapter", title: "Title", summary: "Chapter's Summary", characters: "Characters that appear")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        opaManager.delegate = self
        
    }
    
}

//MARK: - UITextFieldDelegate

extension OPAViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
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
        
        // One cell for each information that I'm returning from the API
        return chapterInformation.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        // Showing for each cell one information from the chapter
        // The array will only contain one OPAModel object, with the necessary information, that's why I'm using only the first row from the array and split the information from this row at the 4 rows at my tableview
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = chapterInformation[0].chapter
        case 1:
            cell.textLabel?.text = chapterInformation[0].title
        case 2:
            cell.textLabel?.text = chapterInformation[0].summary
            cell.textLabel?.numberOfLines = 0
        case 3:
            cell.textLabel?.text = chapterInformation[0].characters
            cell.textLabel?.numberOfLines = 0
        default:
            print("No info registered")
        }
        
        cell.alpha = 0.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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

extension OPAViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
