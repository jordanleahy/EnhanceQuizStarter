//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    // MARK: - Properties
    let questionsPerRound = trivia.count
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    var previousQuestionsArray: [Int] = []
    
    
    // Sound effects variables
    var gameSound: SystemSoundID = 2


    // Lightning Timer Variables
    
    var lightningTimer = Timer()
    var seconds = 15
    var timerRunning = false
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.layer.cornerRadius = 5
        button1.clipsToBounds = true
        button2.layer.cornerRadius = 5
        button2.clipsToBounds = true
        button3.layer.cornerRadius = 5
        button3.clipsToBounds = true
        button4.layer.cornerRadius = 5
        button4.clipsToBounds = true
        playAgainButton.layer.cornerRadius = 5
        playAgainButton.clipsToBounds = true
        loadGameStartSound()
        playGameStartSound()
        // Start Game
        displayQuestion()
    }
    
    // MARK: - Helpers
    
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func displayQuestion() {
        
        
        // Problem: we need to create a function to display random questions on the screen from a list of questions
        // Step 1: Use the GKRandomSource.sharedRandom().nextInt(upperBound: Int) to get a random instance and assign it to the indexOfSelectedQuetion variable which returns an Int
        
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
        
        
        
        // while loop for making sure that questions are not repeated
        while previousQuestionsArray.contains(indexOfSelectedQuestion) {
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
        }
        
        previousQuestionsArray.append(indexOfSelectedQuestion)
       
        
        //Problem: A random Int by itself won't display a question so we need to use that access the trivia array and use the random Int from above and assign that to a new const.
        let questionDictionary = trivia[indexOfSelectedQuestion]
        
        //Problem: Now that we have access to a question, we need to do something with it on the screen.
        //Solution: We use dot notation to access the question stored property and assign it to the questionField.text which is on the inteferace builder
        questionField.text = questionDictionary.question
        playAgainButton.isHidden = true
        
        //Problem: Without including this function, touch, press, keyboard, and focus events are ignored.
        enableButtons() // Line 139:
        
        
        // Problem: We need to put the answer options from the questionDictionary into the questionField.text label of each button.
        // Solution: setTitle:forState instance method.  We use this method to set the title for a button.
        defaultBackGroundColor()
        button1.setTitle(questionDictionary.option1, for: .normal)
        button2.setTitle(questionDictionary.option2, for: .normal)
        button3.setTitle(questionDictionary.option3, for: .normal)
        button4.setTitle(questionDictionary.option4, for: .normal)
        
        playAgainButton.isHidden = true
        resetTimer()
        beginTimer()
    }
    
    
    
    func displayScore() {
        // Hide the answer buttons
        hiddenButtons ()
        timerLabel.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        if correctQuestions == 0 {
            questionField.text = "Looks like you need to study more \n You didn't get any answer correct.  Good luck next time."
        } else if correctQuestions <= 3 {
             questionField.text = "Nice work!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        } else {
             questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        }
       
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
        
        if sender.titleLabel!.text == correctAnswer {
            correctQuestions += 1
            questionField.text = "Correct!"
            
            disableButtons()
            lightningTimer.invalidate()
            timerLabel.text = ""
            sender.backgroundColor = UIColor(red: 102/255, green: 250/255, blue: 51/255, alpha: 0.5)

        } else {
            questionField.text = "Sorry, wrong answer! Correct Answer: \(correctAnswer)"
            disableButtons()
            lightningTimer.invalidate()
            timerLabel.text = ""
            sender.backgroundColor = UIColor(red: 255/255, green: 38/255, blue: 0/255, alpha: 1.0)
        }
        
        loadNextRound(delay: 3)
        
    }
    

    
    @IBAction func playAgain(_ sender: UIButton) {
        // Show the answer buttons
        noteHiddenButtons ()
        
        questionsAsked = 0
        correctQuestions = 0
        previousQuestionsArray.removeAll()
        nextRound()
    }
    
    // Helper Method to enable and disable the buttons after user has answered a question
    // isUserInteractionEnable: A boolean value that determines whether user events are ignored and removed from the event queue
    
    func enableButtons() {
        
        button1.isUserInteractionEnabled = true
        button2.isUserInteractionEnabled = true
        button3.isUserInteractionEnabled = true
        button4.isUserInteractionEnabled = true
    }
    
    func disableButtons () {
        button1.isUserInteractionEnabled = false
        button2.isUserInteractionEnabled = false
        button3.isUserInteractionEnabled = false
        button4.isUserInteractionEnabled = false
    }
    
    func noteHiddenButtons () {
        button1.isHidden = false
        button2.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
    }
    
    func hiddenButtons () {
        button1.isHidden = true
        button2.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
    }
    
    func defaultBackGroundColor () {
        button1.backgroundColor = UIColor(red: 14/255, green: 110/255, blue: 139/255, alpha: 1.0)
        button2.backgroundColor = UIColor(red: 14/255, green: 110/255, blue: 139/255, alpha: 1.0)
        button3.backgroundColor = UIColor(red: 14/255, green: 110/255, blue: 139/255, alpha: 1.0)
        button4.backgroundColor = UIColor(red: 14/255, green: 110/255, blue: 139/255, alpha: 1.0)
    }
    

    
    // Lightning Timer
    
    func beginTimer() {
        
        if timerRunning == false {
            
            lightningTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.countdownTimer), userInfo: nil, repeats: true)
            
            timerRunning = true
        }
    }
    
    @objc func countdownTimer() {
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
        seconds -= 1
        timerLabel.text = timeString(time:TimeInterval(seconds))
        if seconds == 0 {
            lightningTimer.invalidate()
            questionsAsked += 1
            questionField.text = "Sorry, time ran out! \n\n Correct Answer: \(correctAnswer)"
            disableButtons()
            loadNextRound(delay: 3)
        }
    }
    
    func resetTimer() {
        seconds = 15
        timerLabel.text = timeString(time:TimeInterval(seconds))
        timerRunning = false
    }
    
    //Mark: - Formatting Hours, Minutes, Seconds
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    

}


