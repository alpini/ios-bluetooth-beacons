//
//  ViewController.swift
//  BeaconsAttendance
//
//  Created by Vamsi Yechoor on 4/25/17.
//  Copyright © 2017 Vamsi Yechoor. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController, ESTEddystoneManagerDelegate {
    @IBOutlet weak var checkInButton: UIButton!
    
    let eddystoneManager = ESTEddystoneManager()
    var uuid = UUID()
    let url = "https://shibboleth-yechoorv.cloudapps.unc.edu/backend/checkin.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ESTConfig.setupAppID("android-bluetooth-attendan-5bb", andAppToken: "4a5bc182ebecf81fd0e5c20a4fb7155d"); // ESTEddystoneManagerDelegate
        
        eddystoneManager.startEddystoneDiscovery(with: nil)
    }
    
    func eddystoneManager(_ manager: ESTEddystoneManager, didDiscover eddystones: [ESTEddystone], with eddystoneFilter: ESTEddystoneFilter?) {
        if eddystones.count != 0 {
            let beacon = eddystones[0]
            uuid = beacon.peripheralIdentifier
            checkInButton.isEnabled = true
        } else {
            uuid = UUID()
            checkInButton.isEnabled = false
        }
        
    }
    
    @IBAction func checkIn(_ sender: Any) {
        var params = [String: AnyObject]()
        params["onyen"] = "yechoorv" as AnyObject
        params["role"] = "student" as AnyObject
        params["beaconID"] = uuid.uuidString as AnyObject
        
        HTTP.post(urlS: self.url, params: params, completion: { dbData in
            let message = dbData["message"] as! String
            let code = Int(dbData["code"] as! String)
        })
    }
    


}

