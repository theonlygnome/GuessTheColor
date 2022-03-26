//
//  IntroductionViewController.swift
//  GuessTheColor
//
//  Created by Naomi Anderson on 12/17/21.
//

import UIKit

class IntroductionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var charIndex = 0.2
        titleLabel.text = ""
        let titleText = "HUE MATCH"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) {(timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
}
