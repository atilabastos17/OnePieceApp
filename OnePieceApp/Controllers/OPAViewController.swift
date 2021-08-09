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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        opaManager.delegate = self
    }
    
}

//MARK: - UITextFieldDelegate

extension OPAViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
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
        DispatchQueue.main.async {
//            self.chapterNumberLabel.text = chapterNumberInfo.chapter
//            self.chapterTitleLabel.text = chapterNumberInfo.title
//            self.summaryLabel.text = chapterNumberInfo.summary
//            self.charactersLabel.text = chapterNumberInfo.characters
        }

    }
    
    func didFailWithError(_ opaManager: OPAManager, error: Error) {
        print(error)
    }

    
}
