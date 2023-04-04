//
//  ViewController.swift
//  Stopwatch_v02
//
//  Created by Max Franz Immelmann on 4/4/23.
//

import UIKit

class ViewController: UIViewController {

    // Declare variables for the timer
    var timer = Timer()
    var counter = 0.0
    var isRunning = false
    
    // Declare variables for the stopwatch UI
    let circleLayer = CAShapeLayer()
    let secondsLabel = UILabel()
    let startStopButton = UIButton()
    let handLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circle layer
        let circleCenter = CGPoint(x: view.center.x, y: view.center.y - 50)
        let circleRadius = view.bounds.width / 2 - 100
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.lineWidth = 10
        view.layer.addSublayer(circleLayer)
        
        // Set up the seconds label
        secondsLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
//        secondsLabel.center = view.center
        secondsLabel.center = CGPoint(x: view.center.x, y: circleCenter.y + circleRadius + 40)
        secondsLabel.textAlignment = .center
        secondsLabel.font = UIFont.systemFont(ofSize: 30)
        secondsLabel.text = "0.0"
        view.addSubview(secondsLabel)
        
        // Set up the start/stop button
        startStopButton.frame = CGRect(x: 0, y: view.bounds.maxY - 100, width: 100, height: 50)
        startStopButton.center.x = view.center.x
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(UIColor.blue, for: .normal)
        startStopButton.addTarget(self, action: #selector(startStopButtonPressed), for: .touchUpInside)
        view.addSubview(startStopButton)
        
        // Set up the hand layer
        let handPath = UIBezierPath(rect: CGRect(x: -2.5, y: 0, width: 5, height: circleRadius - 30))
        handLayer.path = handPath.cgPath
        handLayer.strokeColor = UIColor.red.cgColor
        handLayer.lineWidth = 5
        handLayer.position = circleCenter
        handLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        circleLayer.addSublayer(handLayer)
    }
    
    @objc func startStopButtonPressed() {
        if isRunning {
            // Stop the timer
            timer.invalidate()
            isRunning = false
            startStopButton.setTitle("Start", for: .normal)
        } else {
            // Start the timer
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isRunning = true
            startStopButton.setTitle("Stop", for: .normal)
        }
    }
    
//    @objc func updateTimer() {
//        counter += 0.1
//        secondsLabel.text = String(format: "%.1f", counter)
//        let angle = 2 * .pi * counter / 60 - .pi / 2
//        let progressPath = UIBezierPath(arcCenter: circleLayer.position, radius: circleLayer.bounds.width / 2, startAngle: -.pi / 2, endAngle: angle, clockwise: true)
//        let progressLayer = CAShapeLayer()
//        progressLayer.path = progressPath.cgPath
//        progressLayer.fillColor = UIColor.clear.cgColor
//        progressLayer.strokeColor = UIColor.red.cgColor
//        progressLayer.lineWidth = 10
//        circleLayer.addSublayer(progressLayer)
//    }
    
    @objc func updateTimer() {
        counter += 0.1
        secondsLabel.text = String(format: "%.1f", counter)
        let angle = 2 * .pi * counter / 60 - .pi / 2
        let progressPath = UIBezierPath(arcCenter: circleLayer.position, radius: circleLayer.bounds.width / 2, startAngle: -.pi / 2, endAngle: angle, clockwise: true)
        let progressLayer = CAShapeLayer()
        progressLayer.path = progressPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.lineWidth = 5
        progressLayer.lineCap = .round
        circleLayer.addSublayer(progressLayer)
        
        // Update the hand position
        let circleCenter = CGPoint(x: view.center.x, y: view.center.y - 50)
        let circleRadius = view.bounds.width / 2 - 100
        let handPath = UIBezierPath()
        handPath.move(to: circleCenter)
        handPath.addLine(to: CGPoint(x: circleCenter.x + circleRadius * CGFloat(cos(angle)), y: circleCenter.y + circleRadius * CGFloat(sin(angle))))
        handLayer.path = handPath.cgPath
    }

}


