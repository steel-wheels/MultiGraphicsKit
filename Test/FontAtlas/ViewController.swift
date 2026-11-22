//
//  ViewController.swift
//  FontAtlas
//
//  Created by Tomoo Hamada on 2026/11/21.
//

import MultiDataKit
import MultiUIKit
import MultiGraphicsKit
import Cocoa

class ViewController: NSViewController
{
        @IBOutlet weak var mImageView: MIImageView!

        override func viewDidLoad() {
                super.viewDidLoad()

                // Do any additional setup after loading the view.
                let font   = MIFont.monospacedSystemFont(ofSize: 24.0, weight: .regular)
                let bitmap = MIAtlasTable()
                let atras  = bitmap.allocateFontAtras(font: font)
                let image  = atras.image
                NSLog("image \(image.size.width) * \(image.size.height)")

                mImageView.image = image
                mImageView.backgroundColor = NSColor.black
                mImageView.explicitContentsSize = image.size
        }

        override var representedObject: Any? {
                didSet {
                // Update the view, if already loaded.
                }
        }


}

