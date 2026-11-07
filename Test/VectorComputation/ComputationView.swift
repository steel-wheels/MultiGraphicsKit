//
//  ComputationView.swift
//  VectorComputation
//
//  Created by Tomoo Hamada on 2026/11/07.
//

import Foundation

import MultiGraphicsKit
import MultiUIKit
import Metal
import MetalKit

public class ComputationView: MIMetalView
{
        private var mDidCalculated = false

        open override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        }

        open override func draw(in view: MTKView) {
                if !mDidCalculated {
                        NSLog("Do calculate")
                        let  result = vectorAddSample(device: self.device)
                        NSLog("result = \(result)")
                        mDidCalculated = true
                }
        }
}

