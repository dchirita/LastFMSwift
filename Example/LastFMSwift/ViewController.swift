//
//  ViewController.swift
//  LastFMSwift
//
//  Created by dv.chirita@gmail.com on 10/09/2020.
//  Copyright (c) 2020 dv.chirita@gmail.com. All rights reserved.
//

import UIKit
import LastFMSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Raw result usage
        // Use commented example
        
        /*
        self.handler.metadataFor(artistName: "Robbie Williams") { result in
            
            switch result {
            case .success(let data):
                debugPrint(data)
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        */
        
        self.artistNameTextField.text = "Robbie Williams"
        self.resultLabel.text = "Result will appear here"
    }
    
    @IBAction func getDataButtonPressed(_ sender: UIButton) {
        
        guard let artistName = self.artistNameTextField.text,
                  artistName.count > 0 else {
                    
                    self.resultLabel.text = "Error. Artist name empty"
                    
                return
        }
        
        self.resultLabel.text = "Searching ..."
        
        self.handler.artistFor(name: artistName) { result in
            
            switch result {
                
            case .success(let artist):
                self.resultLabel.text = artist.bio?.summary
                
            case .failure(let error):
                self.resultLabel.text = "Error: " + error.localizedDescription
            }
        }
    }

    
    private lazy var handler = LastFMHandler(apiKey: "")
    
    @IBOutlet private weak var artistNameTextField: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!
}
