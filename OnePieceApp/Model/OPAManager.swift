//
//  OPAManager.swift
//  OnePieceApp
//
//  Created by Atila Bastos on 24/06/21.
//

import Foundation

protocol OPAManagerDelegate {
    func didUpdateChapter(_ opaManager: OPAManager, chapterNumberInfo: OPAModel)
    func didFailWithError(_ opaManager: OPAManager, error: Error)
}

struct OPAManager {
    let baseURL = "https://onepiececover.com/api/chapters/"
    
    var delegate: OPAManagerDelegate?
    
    func getChapterNumber(for chapterNumber: String) {
        let urlString = "\(baseURL)\(chapterNumber)"
        
        //1. Create URL
        if let url = URL(string: urlString) {
            //2. Create URL Session
            let session = URLSession(configuration: .default)
            //3. Give a task to the session
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(self, error: error!)
                    return
                }
                if let safeData = data {
                    if let chapterNumberInfo = self.parseJSON(safeData) {
                        delegate?.didUpdateChapter(self, chapterNumberInfo: chapterNumberInfo)
                    }
                    
                }
            }
            //4. Execute the task
            task.resume()
        }

    }
    
    func parseJSON(_ data: Data) -> OPAModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(OPAData.self, from: data)
            
            // Decoding the informations that I found relevant to show
            let chapter = decodedData.chapter
            let title = decodedData.title
            let summary = decodedData.summary
            let characters = decodedData.characters
            
            // Storing it on a constant to return the correct type of the function
            let chapterInfo = OPAModel(chapter: chapter, title: title, summary: summary, characters: characters)
            return chapterInfo
            
        } catch {
            delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
    
}
