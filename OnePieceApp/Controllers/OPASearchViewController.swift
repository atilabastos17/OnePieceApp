//
//  ViewController.swift
//  OnePieceApp
//
//  Created by Atila Bastos on 24/06/21.
//

import UIKit

class OPASearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var opaManager = OPAManager()
    var model: OPAModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opaManager.delegate = self
        
        // Customizing the search button
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        searchButton.backgroundColor = UIColor.brown.withAlphaComponent(0.75)
        
        // Customizing the searchTextField
        searchTextField.layer.cornerRadius = 10
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter a chapter number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        let myColor: UIColor = UIColor.white
        searchTextField.layer.borderColor = myColor.cgColor
        searchTextField.layer.borderWidth = 1.0
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
        // Checking if the input is valid
        if searchTextField.text != "" {
            if let chapter = searchTextField.text {
                opaManager.getChapterNumber(for: chapter)
            }
            // Changing the placeholder text after a succesful search
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Enter a chapter number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        } else {
            searchTextField.attributedPlaceholder = NSAttributedString(string: "You must type a chapter number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        
        // Making the searchTextField empty after a search
        searchTextField.text = ""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchToSummary") {
            let summaryVC = segue.destination as? OPASummaryViewController
            summaryVC?.chapterRequested = model
        }
    }
    
}

//MARK: - OPAManagerDelegate

extension OPASearchViewController: OPAManagerDelegate {
    
    func didUpdateChapter(_ opaManager: OPAManager, chapterNumberInfo: OPAModel) {
        
        // Storing the chapter info from the delegate method on a constant and giving the model variable his information
        let newChapterInfo = OPAModel(chapter: chapterNumberInfo.chapter, title: chapterNumberInfo.title, summary: chapterNumberInfo.summary, characters: chapterNumberInfo.characters)
        
        model = newChapterInfo
        
        // Making the performSegue after the API request is done and my model is filled with the data from the request
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "searchToSummary", sender: self)
        }
    }
    
    func didFailWithError(_ opaManager: OPAManager, error: Error) {
        print(error)
    }
}
