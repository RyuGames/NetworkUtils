//
//  ViewController.swift
//  NetworkUtils
//
//  Created by WyattMufson on 12/03/2018.
//  Copyright (c) 2018 WyattMufson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(note:)),
                                               name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }

    @objc func reachabilityChanged(note: Notification) {
        if let reachability = note.object as? Reachability {
            switch reachability.connection {
            case .wifi:
                print("Reachable via WiFi")
            case .cellular:
                print("Reachable via Cellular")
            case .none:
                print("Not Reachable")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
