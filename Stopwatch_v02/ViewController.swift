//
//  ViewController.swift
//  Stopwatch_v02
//
//  Created by Max Franz Immelmann on 4/4/23.
//

import UIKit

class ViewController: UIViewController {
    let circleLayer = CAShapeLayer()
    let handLayer = CAShapeLayer()
    var counter = 0.0
    var timer = Timer()
    
    let startStopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self,
                         action: #selector(startStopButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let secondsLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.font = UIFont.systemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the circle layer
        let circleCenter = CGPoint(x: view.center.x, y: view.center.y)
        let circleRadius = view.bounds.width / 2 * 0.90
        let circlePath = UIBezierPath(arcCenter: circleCenter,
                                      radius: circleRadius,
                                      startAngle: 0,
                                      endAngle: 2 * .pi,
                                      clockwise: true)
        
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.lineWidth = 10
        view.layer.addSublayer(circleLayer)

        /*
        // Set up the hand layer
        handLayer.fillColor = UIColor.red.cgColor
        handLayer.strokeColor = UIColor.red.cgColor
        handLayer.lineWidth = 5
        view.layer.addSublayer(handLayer)
         */
        
        // Set up the hand layer
        let handPath = UIBezierPath()
        handPath.move(to: view.center)
        handPath.addLine(to: CGPoint(x: view.center.x, y: view.center.y - circleRadius))
        handLayer.path = handPath.cgPath
        handLayer.strokeColor = UIColor.red.cgColor
        handLayer.lineWidth = 3
        handLayer.lineCap = .round
        view.layer.addSublayer(handLayer)

        // Add the start/stop button and seconds label
        view.addSubview(startStopButton)
        view.addSubview(secondsLabel)

        NSLayoutConstraint.activate([
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startStopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -20),
            secondsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondsLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                              constant: 100),
        ])
    }
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the circle layer
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.lineWidth = 4
        let radius = view.bounds.width / 2 - 20
        circleLayer.path = UIBezierPath(arcCenter: view.center, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        view.layer.addSublayer(circleLayer)
        
        // Set up the hand layer
        let handPath = UIBezierPath()
        handPath.move(to: view.center)
        handPath.addLine(to: CGPoint(x: view.center.x, y: view.center.y - radius))
        handLayer.path = handPath.cgPath
        handLayer.strokeColor = UIColor.red.cgColor
        handLayer.lineWidth = 3
        handLayer.lineCap = .round
        view.layer.addSublayer(handLayer)
        
        // Set up the seconds label
        secondsLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 80, weight: .medium)
        secondsLabel.textAlignment = .center
        secondsLabel.text = "0.0"
        view.addSubview(secondsLabel)
        
        // Set up the start/stop button
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.backgroundColor = .blue
        startStopButton.setTitleColor(.white, for: .normal)
        startStopButton.layer.cornerRadius = 10
        startStopButton.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
        view.addSubview(startStopButton)
        
        // Position the seconds label and start/stop button
        secondsLabel.frame = CGRect(x: 0,
                                    y: view.center.y + radius + 20,
                                    width: view.bounds.width,
                                    height: 100)
        startStopButton.frame = CGRect(x: 20,
                                       y: view.bounds.height - 80,
                                       width: view.bounds.width - 40,
                                       height: 60)
    }
     */

    
    
    @objc func updateTimer() {
        counter += 0.1
        secondsLabel.text = String(format: "%.1f", counter)
        let angle = 2 * .pi * counter / 60 - .pi / 2
        let progressPath = UIBezierPath(arcCenter: circleLayer.position,
                                        radius: circleLayer.bounds.width / 2,
                                        startAngle: -.pi / 2,
                                        endAngle: angle,
                                        clockwise: true)
        let progressLayer = CAShapeLayer()
        progressLayer.path = progressPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.lineWidth = 5
        progressLayer.lineCap = .round
        circleLayer.addSublayer(progressLayer)
        
        // Update the hand position
        let circleCenter = CGPoint(x: view.center.x, y: view.center.y)
        let circleRadius = view.bounds.width / 2 * 0.90
        let handPath = UIBezierPath()
        handPath.move(to: circleCenter)
        handPath.addLine(to: CGPoint(x: circleCenter.x + circleRadius * CGFloat(cos(angle)),
                                     y: circleCenter.y + circleRadius * CGFloat(sin(angle))))
        handLayer.path = handPath.cgPath
    }
    
    @objc func startStopButtonTapped() {
        if timer.isValid {
            timer.invalidate()
            startStopButton.setTitle("Start", for: .normal)
        } else {
            counter = 0.0
            secondsLabel.text = "0.0"
            handLayer.path = nil
            for sublayer in circleLayer.sublayers ?? [] {
                sublayer.removeFromSuperlayer()
            }
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
            startStopButton.setTitle("Stop", for: .normal)
        }
    }
}

