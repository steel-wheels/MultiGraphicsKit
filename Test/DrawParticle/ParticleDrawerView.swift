//
//  ParticleDrawerView.swift
//  DrawParticle
//
//  Created by Tomoo Hamada on 2026/09/25.
//

import MultiGraphicsKit
import MultiUIKit
import Metal
import MetalKit

public class ParticleDrawerView: MIMetalView
{
        private var mDidCalculated: Bool = false

        open override func setup(frame frm: CGRect) {
                super.setup(frame: frm)
        }

        open override func draw(in view: MTKView) {
                if !mDidCalculated {
                        NSLog("Do calculate")
                        let result = graphicsDriver(device: self.metalDevice)
                        NSLog("result = \(result)")
                        mDidCalculated = true
                }
        }
}

