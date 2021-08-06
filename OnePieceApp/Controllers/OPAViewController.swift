//
//  ViewController.swift
//  OnePieceApp
//
//  Created by Atila Bastos on 24/06/21.
//

import UIKit

class OPAViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var chapterNumberLabel: UILabel!
    @IBOutlet weak var chapterTitleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var charactersLabel: UILabel!
    
    var opaManager = OPAManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chapterNumberLabel.alpha = 0.5
        chapterTitleLabel.alpha = 0.5
        summaryLabel.alpha = 0.5
        charactersLabel.alpha = 0.5
        
        searchTextField.delegate = self
        opaManager.delegate = self
    }
    
}

//MARK: - UITextFieldDelegate

extension OPAViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        chapterNumberLabel.alpha = 1
        chapterTitleLabel.alpha = 1
        summaryLabel.alpha = 1
        charactersLabel.alpha = 1
        
        summaryLabel.numberOfLines = 0
        charactersLabel.numberOfLines = 0
        
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
            self.chapterNumberLabel.text = chapterNumberInfo.chapter
            self.chapterTitleLabel.text = chapterNumberInfo.title
            self.summaryLabel.text = chapterNumberInfo.summary
            self.charactersLabel.text = chapterNumberInfo.characters
        }

    }
    
    func didFailWithError(_ opaManager: OPAManager, error: Error) {
        print(error)
    }

    
}
