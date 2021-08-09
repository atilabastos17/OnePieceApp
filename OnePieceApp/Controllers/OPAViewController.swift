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
    var opaModel = [OPAModel(chapter: "", title: "", summary: "", characters: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        tableView.dataSource = self
        opaManager.delegate = self
        
    }
    
}

//MARK: - UITextFieldDelegate

extension OPAViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        opaModel = []
        
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
        let newChapterInfo = OPAModel(chapter: chapterNumberInfo.chapter, title: chapterNumberInfo.title, summary: chapterNumberInfo.summary, characters: chapterNumberInfo.characters)
        
        self.opaModel.append(newChapterInfo)
        
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        // Showing for each cell one information from the chapter
        if indexPath.row == 0 {
            cell.textLabel?.text = opaModel[0].chapter
        } else if indexPath.row == 1 {
            cell.textLabel?.text = opaModel[0].title
        } else if indexPath.row == 2 {
            cell.textLabel?.text = opaModel[0].summary
        } else if indexPath.row == 3 {
            cell.textLabel?.text = opaModel[0].characters
        } else {
            print("No info registered")
        }
        
//        switch indexPath.row {
//        case 0:
//            cell.textLabel?.text = opaModel[0].chapter
//        case 1:
//            cell.textLabel?.text = opaModel[0].title
//        case 2:
//            cell.textLabel?.text = opaModel[0].summary
//        case 3:
//            cell.textLabel?.text = opaModel[0].characters
//        default:
//            print("No info registered")
//        }
        
        return cell
    }
    
    
}
