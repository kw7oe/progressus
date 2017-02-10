//
//  ViewController.swift
//  Countdown
//
//  Created by Choong Kai Wern on 10/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    
    var time: Int {
        if !Settings.dateStarted { return 0 }
        return -Int(Settings.date.timeIntervalSinceNow)
    }    
    var timer = Timer()
    
    // MARK : View Outlet
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var button: RadiusButton!
    @IBOutlet weak var timeUnitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: ProgressPieView! 
    
    // MARK: Target Action
    @IBAction func resetTime(_ sender: UIButton) {
        if Settings.dateStarted {
            resetTimer()
        } else {
            startTimer()
        }
    }
    
    private func resetTimer() {
        let alertController = UIAlertController(title: "Are you sure you want to reset?", message: nil, preferredStyle: .alert)
        alertController.transitioningDelegate = self
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { (action) in
                    Settings.date = Date.init()
                    Settings.dateStarted = false
                    self.button.setTitle("START", for: .normal)
                    self.setProgress()
                    self.updateUI()
                }
            )
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func startTimer() {
        Settings.date = Date.init()
        button.setTitle("RESET", for: .normal)
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { (timer) in
                self.updateUI()
        })
    }
    
    // MARK: Private Methods
    private func updateUI() {
        updateDescription()
        updateTime()
    }
    
    private func updateTime() {
        timeLabel.text = String(time)
        timeUnitLabel.text = "second"
        if time > 1 {
            timeUnitLabel.text = "seconds"
        }
    }
    
    private func updateDescription() {
        let results = Parser.parseToArray(time: time, basedOn: Parser.Format.DayHour)
        descriptionLabel.text = results[0].time + results[0].unit + results[1].time + results[1].unit
    }
    
    
    private func updateQuote() {
        let quote = Quotes.getRandomQuotes()
        quoteLabel.text = quote.content
        authorLabel.text = quote.author
    }
    
    private func setProgress() {
        let parseResult = Parser.parseToArray(time: time, basedOn: Parser.Format.Hour)[0]
        let progressHour = Int(parseResult.time)!
        let percentage = (CGFloat(progressHour) / CGFloat(Settings.goal * 24))
        progressView.setProgress(with: percentage)
    }
    
    // MARK: View Controller Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.none()
        self.view.window?.tintColor = Color.primaryColor()
        self.view.backgroundColor = Color.backgroundColor()
        
        // Dark Theme
        descriptionLabel.updateFontColor()
        timeLabel.updateFontColor()
        timeUnitLabel.updateFontColor()
        authorLabel.updateFontColor()
        quoteLabel.updateFontColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgress()
        if Settings.dateStarted {
            button.setTitle("RESET", for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.updateUI()
            })
        }
    }
}

// MARK: UIViewController Transitioning Delegate Extension
extension CounterViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
}

extension UINavigationBar {
    /** 
    Remove Background and Bottom Border of Nagivation Bar
     */
    func none() {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.barTintColor = UIColor.white
        self.shadowImage = UIImage()
    }
}

extension UILabel {
    
    // Dark Theme
    func updateFontColor() {
        self.textColor = Color.textColor()
    }
}




