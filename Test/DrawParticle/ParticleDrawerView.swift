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
        //private var mTarget:                  TargetType              = .vectorAdd
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
                        drawer.setViewportSize(size: self.metalView.frame.size)
                        mImageTextureDrawer = drawer
                }
        }

        open override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
                switch mTarget {
                case .vectorAdd:
                        break
                case .imageTexture:
                        if let drawer = mImageTextureDrawer {
                                drawer.setViewportSize(size: size)
                        }
                }
        }

        open override func draw(in view: MTKView) {
                switch mTarget {
                case .vectorAdd:
                        if !mDidCalculated {
                                NSLog("Do calculate")
                                let  result = vectorAddSample(device: self.device)
                                NSLog("result = \(result)")
                                mDidCalculated = true
                        }
                case .imageTexture:
                        if let drawer = mImageTextureDrawer {
                                drawer.draw()
                        }
                }
        }
}

