//
//  ParticleDrawerView.swift
//  DrawParticle
//
//  Created by Tomoo Hamada on 2026/09/25.
//

import MultiGraphicsKit
import MultiUIKit
import MetalKit

public class ParticleDrawerView: MIMetalView
{
        static let NumberOfPoints       = 1

        open override func setup(frame frm: CGRect) {
                super.setup(frame: frm)
        }

        public override func allocateBuffers(device: MIMetalDevice) -> Array<MTLBuffer> {
                let length: Int = GPoint2f.size() * ParticleDrawerView.NumberOfPoints
                let buffer: MTLBuffer = device.makeBuffer(length: length,
                                                          options: .storageModeShared)
                return [buffer]
        }

        public override func allocateFunctions(library lib: MTLLibrary) -> Array<MTLFunction> {
                return []
        }
}

