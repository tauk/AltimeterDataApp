//
//  ViewController.swift
//  AltimeterDataApp
//
//  Created by Tauseef Kamal on 06/09/2023.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    
    private var pressure: Double = 0
    private var altitude: Double = 0
    
    private let altimeter = CMAltimeter()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        startAltimeterUpdates() // Start Altimeter updates
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAltimeterUpdates()
    }
        
    private func startAltimeterUpdates() {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            print("Relative altitude is not available on this device.")
            return
        }
            
        altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
            if let data = data {
                self.pressure = Double(truncating: data.pressure)
                self.altitude = Double(truncating: data.relativeAltitude)
                self.updateLabel()
            } else if let error = error {
                print("Error fetching altitude data: \(error.localizedDescription)")
            }
        }
    }
        
    private func updateLabel() {
        dataLabel.text = "Pressure: \(String(format:"%.3f", pressure)) kpa\nAltitude change: \(String(format:"%.3f", altitude)) m"
    }

    private func stopAltimeterUpdates() {
        altimeter.stopRelativeAltitudeUpdates()
    }
}

