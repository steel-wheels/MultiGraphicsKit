//
//  ViewController.swift
//  AsciiDrawer
//
//  Created by Tomoo Hamada on 2026/11/22.
//

import Cocoa

class ViewController: NSViewController
{
        @IBOutlet var mTextView: TextView!

        override func viewDidLoad() {
                super.viewDidLoad()

                // Do any additional setup after loading the view.
                NSLog("viewDidLoad")
        }

        override var representedObject: Any? {
                didSet {
                        // Update the view, if already loaded.
                }
        }
}

