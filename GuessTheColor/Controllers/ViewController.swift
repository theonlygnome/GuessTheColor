//
//  ViewController.swift
//  GuessTheColor
//
//  Created by Naomi Anderson on 11/14/21.
//

import AVFoundation
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
        
    @IBOutlet weak var playPause: UIBarButtonItem!
    
    @IBOutlet weak var imageBackground: UIImageView!
    
    
    // not set as optional because this will always be set to an array of the four option buttons
    var buttonOptionArr : [UIButton] = []
     
    var correctSelection = 0
    
    var totalTurns = 0
    var totalCorrect = 0
    var streak = 0
    var highStreak = 0
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        buttonOptionArr = [option1, option2, option3, option4]
        //scoreLabel.text = "\(totalCorrect) Correct /  \(totalTurns) Total"
        
        scoreLabel.text = "Score: \(streak)"
        longestStreak.text = "Streak: \(highStreak)"
        changeColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Make sure that if the game starts as landscape, the orientation is shifted before displaying
        if UIDevice.current.orientation.isLandscape {
            allColorStackView.axis = .vertical
            guessColorStackView.axis = .horizontal
        }
        
        playPause.image = UIImage(systemName: "play.circle")
        
        scoreLabel.font = UIFont(name: "GillSans", size: 20)
        longestStreak.font = UIFont(name: "GillSans", size: 20)
        swatch.layer.cornerRadius = 10.0
        option1.layer.cornerRadius = 10.0
        option2.layer.cornerRadius = 10.0
        option3.layer.cornerRadius = 10.0
        option4.layer.cornerRadius = 10.0
        imageBackground.alpha = 0.2
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
        scoreLabel.text = "Score: \(streak)"
        longestStreak.text = "Streak: \(highStreak)"
    }
    
    
    @IBAction func resetGame(_ sender: UIButton) {
        totalCorrect = 0
        totalTurns = 0
        streak = 0
        
        
        //scoreLabel.text = "Score: \(totalCorrect) / \(totalTurns)"
        scoreLabel.text = "Score: \(streak)"
        longestStreak.text = "Streak: \(highStreak)"
        changeColor()
        
       }
    
    @IBAction func playPauseTapped(_ sender: UIBarButtonItem) {
        if let player = player, player.isPlaying {
            player.stop()
            playPause.image = UIImage(systemName: "play.circle")
        } else {
            playPause.image = UIImage(systemName: "pause.circle")
            
            let urlString = Bundle.main.path(forResource: "calm", ofType: ".mp3")
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let urlString = urlString else {
                    return
                }
                
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                player?.numberOfLoops = 100
                guard let player = player else {
                    return
                }
                
                player.play()
            } catch {
                print("Error starting music")
            }
            
        }
    }
}

