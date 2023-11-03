//
//  ViewController.swift
//  GuessTheColor
//
//  Created by Naomi Anderson on 11/14/21.
//

import AVFoundation
import UIKit

class ViewController: UIViewController, UIDragInteractionDelegate, UIDropInteractionDelegate {

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
                
        let defaults = UserDefaults.standard
        highStreak = defaults.integer(forKey: "streak")
        
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
        swatch.setTitle("", for: .normal)
        option1.setTitle("", for: .normal)
        option2.setTitle("", for: .normal)
        option3.setTitle("", for: .normal)
        option4.setTitle("", for: .normal)
        swatch.layer.cornerRadius = 10.0
        option1.layer.cornerRadius = 10.0
        option2.layer.cornerRadius = 10.0
        option3.layer.cornerRadius = 10.0
        option4.layer.cornerRadius = 10.0
        imageBackground.alpha = 0.2
        
        swatch.isUserInteractionEnabled = true
        option1.isUserInteractionEnabled = true
        option2.isUserInteractionEnabled = true
        option3.isUserInteractionEnabled = true
        option4.isUserInteractionEnabled = true
        
        let dragInteraction1 = UIDragInteraction(delegate: self)
        swatch.addInteraction(dragInteraction1)
        
        let dropInteration1 = UIDropInteraction(delegate: self)
        let dropInteration2 = UIDropInteraction(delegate: self)
        let dropInteration3 = UIDropInteraction(delegate: self)
        let dropInteration4 = UIDropInteraction(delegate: self)
        option1.addInteraction(dropInteration1)
        option2.addInteraction(dropInteration2)
        option3.addInteraction(dropInteration3)
        option4.addInteraction(dropInteration4)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Writing out user defaults")
        let defaults = UserDefaults.standard
        if highStreak == 0 {
            defaults.set(totalCorrect, forKey: "streak")
        } else {
            defaults.set(highStreak, forKey: "streak")
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
        
        // Adjust in the other direction if the color is too close to black
        if r < 40 {
            guesses[0] = UIColor(red: CGFloat(r+80)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
        }
        if g < 40 {
            guesses[1] = UIColor(red: CGFloat(r)/255, green: CGFloat(g+80)/255, blue: CGFloat(b)/255, alpha: 1.0)
        }
        if b < 40 {
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
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let button = interaction.view as? UIButton, let title = button.titleLabel?.text else {
            return []
        }
        
        let provider = NSItemProvider(object: title as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = button
        return [dragItem]
        
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSString.self) { _ in
                if let destinationButton = interaction.view as? UIButton {
                    print("Destination tag is \(destinationButton.tag)")
                    if destinationButton.tag == self.correctSelection {
                        self.totalCorrect += 1
                        self.streak += 1
                        self.changeColor()
                    } else {
                        if (self.streak > self.highStreak) {
                            self.highStreak = self.streak
                        }
                        self.streak = 0
                    }
                    
                    self.totalTurns += 1
                    
                    self.scoreLabel.text = "Score: \(self.streak)"
                    self.longestStreak.text = "Streak: \(self.highStreak)"
                }
            
        }
    }
}

