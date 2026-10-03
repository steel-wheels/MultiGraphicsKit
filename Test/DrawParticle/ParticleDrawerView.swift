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
                let inputvec: Array<Vector4f> = [
                        Vector4f(elements: [0.0, 0.0, 0.0, 0.0]),
                        Vector4f(elements: [1.0, 1.0, 1.0, 1.0]),
                        Vector4f(elements: [2.0, 2.0, 2.0, 2.0]),
                        Vector4f(elements: [3.0, 3.0, 3.0, 3.0]),
                ]
                let inputbuf = Vector4f.makeBuffer(device: device, vectors: inputvec)
                return [inputbuf]
        }

        public override func allocateFunctions(library lib: MTLLibrary) -> Array<MTLFunction> {
                return []
        }
}

