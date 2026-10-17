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
        public enum TargetType {
                case vectorAdd
                case imageTexture
        }

        private var mTarget:            TargetType      = .imageTexture
        private var mDidCalculated:     Bool            = false

        open override func setup(frame frm: CGRect) {
                super.setup(frame: frm)
        }

        open override func draw(in view: MTKView) {
                if !mDidCalculated {
                        NSLog("Do calculate")
                        let result: Bool
                        switch mTarget {
                        case .vectorAdd:        result = vectorAddSample(device: self.device)
                        case .imageTexture:     result = imageTextureSample(device: self.device)
                        }
                        NSLog("result = \(result)")
                        mDidCalculated = true
                }
        }
}

