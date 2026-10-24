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

        private var mTarget:                    TargetType              = .imageTexture
        private var mDidCalculated:             Bool                    = false
        private var mImageTextureDrawer:        ImageTextureDrawer?     = nil

        open override func setup(frame frm: CGRect) {
                super.setup(frame: frm)
                switch mTarget {
                case .vectorAdd:
                        break
                case .imageTexture:
                        let drawer = ImageTextureDrawer(view: self.metalView, device: self.device)
                        drawer.setup()
                        mImageTextureDrawer = drawer
                }
        }

        open override func draw(in view: MTKView) {
                if !mDidCalculated {
                        NSLog("Do calculate")
                        let result: Bool
                        switch mTarget {
                        case .vectorAdd:
                                result = vectorAddSample(device: self.device)
                        case .imageTexture:
                                if let drawer = mImageTextureDrawer {
                                        drawer.draw()
                                        result = true
                                } else {
                                        result = false
                                }
                        }
                        NSLog("result = \(result)")
                        mDidCalculated = true
                }
        }
}

