//
//  ViewController.swift
//  ClockApp2
//
//  Created by Nicole Mills on 2/5/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var buttonText: UIButton!
    @IBOutlet weak var timeSelect: UIDatePicker!
    @IBOutlet weak var background: UIImageView!
    weak var timer: Timer?
    var clockTimer = Timer()
    var timeLeft : Int?
    var alarm: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentTime()
        timeRemainingLabel.text = ""
        
        guard let path = Bundle.main.path(forResource: "Alarm", ofType:"mp3")
        else {print("not found")
            return}
        let url = URL(fileURLWithPath: path)
        do{
            alarm = try AVAudioPlayer(contentsOf: url)
        }catch{}
    }
    
    @IBAction func startTimerButton(_ sender: UIButton) {
        if (buttonText.currentTitle == "Stop Timer") {
            stopMusic()
            buttonText.setTitle("Start", for: .normal)
        }
        else {
            let date = timeSelect.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let hour = components.hour!
            let minute = components.minute!
            
            timeLeft = hour * 3600 + minute * 60
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(startCountDown) , userInfo: nil, repeats: true)
            buttonText.setTitle("Stop Timer", for: .normal)
        }
    }
    
    private func getCurrentTime() {
            clockTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }
    
    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd  yyyy hh:mm:ss"
        currentTimeLabel.text = formatter.string(from: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        let date = dateFormatter.string(from: Date())
        
        if(date.contains(dateFormatter.amSymbol)){
            background.image = UIImage(named:"KoreaDay")
        }
        else {
            background.image = UIImage(named:"KoreaNight")
        }
    }
    
    @objc func startCountDown() {
        if (timeLeft! >= 0) {
            timeRemainingLabel.text = "\(timeLeft!)"
            timeLeft! -= 1
        }
        else {
            playMusic();
        }
    }
    
    func playMusic() {
        alarm?.play()
    }
    
    func stopMusic() {
        alarm?.pause()
    }
}
