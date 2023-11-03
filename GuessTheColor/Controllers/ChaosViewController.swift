//
//  ChaosViewController.swift
//  GuessTheColor
//
//  Created by Naomi Anderson on 8/8/23.
//

import UIKit

class ChaosViewController: UIViewController {
    
    @IBOutlet weak var highStreak: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var score: UILabel!

    @IBOutlet weak var swatch: UIButton!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var allColorStackView: UIStackView!
    @IBOutlet weak var guessColorStackView: UIStackView!
    
    @IBOutlet weak var imageView: UIImageView!
 
    var buttonOptionArr : [UIButton] = []
    
    var correctSelection = 0
    
    var totalTurns = 0
    var totalCorrect = 0
    var streak = 0
    var topStreak = 0
    
    var counter = 30
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        topStreak = defaults.integer(forKey: "chaosStreak")
        imageView.alpha = 0.1
        
        buttonOptionArr = [button1, button2, button3, button4]
        //scoreLabel.text = "\(totalCorrect) Correct /  \(totalTurns) Total"
        
        score.text = "Score: \(streak)"
        highStreak.text = "Streak: \(topStreak)"
        changeColor()
        setupButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Make sure that if the game starts as landscape, the orientation is shifted before displaying
        if UIDevice.current.orientation.isLandscape {
            allColorStackView.axis = .vertical
            guessColorStackView.axis = .horizontal
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Writing out user defaults")
        let defaults = UserDefaults.standard
        if topStreak == 0 {
            defaults.set(totalCorrect, forKey: "chaosStreak")
        } else {
            defaults.set(topStreak, forKey: "chaosStreak")
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
    
    @objc func update() {
        if(counter > 0) {
            counter -= 1
            timerLabel.text = String(counter)
        } else {
            timer?.invalidate()
            
            timerLabel.isHidden = true
            
            // if score is higher than streak, update streak
            if (streak > topStreak) {
                topStreak = streak
            }
            
            // Leave score as is and don't set back to zero until restarting timer
            // but copy over high score
            score.text = "Score: \(streak)"
            highStreak.text = "Streak: \(topStreak)"
        }
        
    }
    
    private func setupButtons() {
        
        score.font = UIFont(name: "GillSans", size: 20)
        highStreak.font = UIFont(name: "GillSans", size: 20)
        swatch.setTitle("", for: .normal)
        button1.setTitle("", for: .normal)
        button2.setTitle("", for: .normal)
        button3.setTitle("", for: .normal)
        button4.setTitle("", for: .normal)
        swatch.layer.cornerRadius = 10.0
        button1.layer.cornerRadius = 10.0
        button2.layer.cornerRadius = 10.0
        button3.layer.cornerRadius = 10.0
        button4.layer.cornerRadius = 10.0
    }
    
    func changeColor() {
        let r = Int.random(in: 0...255)
        let g = Int.random(in: 0...255)
        let b = Int.random(in: 0...255)
        
        // print("red: \(r), green: \(g), blue: \(b)")
        swatch.backgroundColor = UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
        
        var guesses = [ UIColor(red: CGFloat(r-40)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0),
                        UIColor(red: CGFloat(r)/255, green: CGFloat(g-40)/255, blue: CGFloat(b)/255, alpha: 1.0),
                        UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b-40)/255, alpha: 1.0)]
        
        // Adjust in the other direction if the color is too close to black
        if r < 80 {
            guesses[0] = UIColor(red: CGFloat(r+80)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
        }
        if g < 80 {
            guesses[1] = UIColor(red: CGFloat(r)/255, green: CGFloat(g+80)/255, blue: CGFloat(b)/255, alpha: 1.0)
        }
        if b < 80 {
            guesses[2] =  UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b+80)/255, alpha: 1.0)
        }
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func guessTapped(_ sender: UIButton) {
        if let _ = timer {
            if counter > 0 {
                let selection = sender.tag
                if (selection == correctSelection) {
                    totalCorrect += 1
                    streak += 1
                    changeColor()
//                    if swatch.backgroundColor != sender.backgroundColor {
//                        print("SWATCH AND GUESS ARE DIFFERENT!!")
//                        print("Swatch: \(swatch.backgroundColor!)")
//                        print("Guess: \(sender.backgroundColor!)")
//                    }
                } else {
                    if swatch.backgroundColor == sender.backgroundColor {
                        print("THE COLORS WERE THE SAME BUT NOT THE CORRECT COLOR")
                        print("Swatch: \(swatch.backgroundColor!)")
                        print("Guess: \(sender.backgroundColor!)")
                    }
                }
                
                totalTurns += 1
                
                //scoreLabel.text = "Score: \(totalCorrect) / \(totalTurns)"
                score.text = "Score: \(streak)"
                highStreak.text = "Streak: \(topStreak)"
            } else {
                print("Timer has run out")
            }
        } else {
            print("Timer not going, nothing will happen.")
        }
    }
    
    @IBAction func startTapped(_ sender: UIBarButtonItem) {
        if let existingTimer = timer {
            existingTimer.invalidate()
            if (streak > topStreak) {
                    topStreak = streak
            }
            streak = 0
            totalCorrect = 0
            score.text = "Score: \(streak)"
            highStreak.text = "Streak: \(topStreak)"
            counter = 30
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
}
