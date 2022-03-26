//
//  ViewController.swift
//  GuessTheColor
//
//  Created by Naomi Anderson on 11/14/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    @IBOutlet weak var swatch: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var longestStreak: UILabel!
    
    @IBOutlet weak var allColorStackView: UIStackView!
    @IBOutlet weak var guessColorStackView: UIStackView!
        
    // not set as optional because this will always be set to an array of the four option buttons
    var buttonOptionArr : [UIButton] = []
     
    var correctSelection = 0
    
    var totalTurns = 0
    var totalCorrect = 0
    var streak = 0
    var highStreak = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        buttonOptionArr = [option1, option2, option3, option4]
        //scoreLabel.text = "\(totalCorrect) Correct /  \(totalTurns) Total"
        
        scoreLabel.text = "Streak: \(streak)"
        longestStreak.text = "Longest Streak: \(highStreak)"
        changeColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Make sure that if the game starts as landscape, the orientation is shifted before displaying
        if UIDevice.current.orientation.isLandscape {
            allColorStackView.axis = .vertical
            guessColorStackView.axis = .horizontal
        }
    }

    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            allColorStackView.axis = .vertical
            guessColorStackView.axis = .horizontal
        } else {
            allColorStackView.axis = .horizontal
            guessColorStackView.axis = .vertical
        }
    }
    
  
    
    func changeColor() {
        let r = Int.random(in: 0...255)
        let g = Int.random(in: 0...255)
        let b = Int.random(in: 0...255)
        
        print("red: \(r), green: \(g), blue: \(b)")
        swatch.backgroundColor = UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
        
        var guesses = [ UIColor(red: CGFloat(r-40)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0),
                        UIColor(red: CGFloat(r)/255, green: CGFloat(g-40)/255, blue: CGFloat(b)/255, alpha: 1.0),
                        UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b-40)/255, alpha: 1.0)]
        
        // Randomly select which button will hold the correct option
        correctSelection = Int.random(in: 0...3)
        
        for i in 0 ..< buttonOptionArr.count {
            if i == correctSelection {
                buttonOptionArr[i].backgroundColor = UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
            } else {
                buttonOptionArr[i].backgroundColor = guesses[0]
                // Once the guess has been used, remove it.  There is probably a slicker way of doing this
                guesses.remove(at: 0)
            }

        }
        
    }
    
    @IBAction func guessSelected(_ sender: UIButton) {
        let selection = sender.tag
        if (selection == correctSelection) {
            totalCorrect += 1
            streak += 1
            changeColor()
        } else {
            if (streak > highStreak) {
                highStreak = streak
            }
            streak = 0
        }
        
        totalTurns += 1
        
        //scoreLabel.text = "Score: \(totalCorrect) / \(totalTurns)"
        scoreLabel.text = "Streak: \(streak)"
        longestStreak.text = "Longest Streak: \(highStreak)"
    }
    
    
    @IBAction func resetGame(_ sender: UIButton) {
        totalCorrect = 0
        totalTurns = 0
        streak = 0
        
        
        //scoreLabel.text = "Score: \(totalCorrect) / \(totalTurns)"
        scoreLabel.text = "Streak: \(streak)"
        longestStreak.text = "Longest Streak: \(highStreak)"
        changeColor()
        
       }
    
}

