/*
 * @file MIPipelineState.swift
 * @description Define classes for pipeline state
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import MultiUIKit
import Metal
import MetalKit
#if os(OSX)
import AppKit
#else
import UIKit
#endif

public class MIRenderPipelineState
{
        public static func allocateTextureRenderPipelineState(view: MTKView) throws -> MTLRenderPipelineState {
                guard let dev = view.device else {
                        throw MIGraphicsError.nullObject
                }
                let lib = try dev.loadLibrary()
                let vertexFunction = try lib.makeFunction(builtIn: .vertexShader)
                let shaderFunction = try lib.makeFunction(builtIn: .samplingShader)
                return try allocateRenderPipelineState(view: view, device: dev, vertexFunc: vertexFunction, fragmentFunc: shaderFunction)
        }

        private static func allocateRenderPipelineState(view: MTKView, device dev: MTLDevice, vertexFunc verfunc: MTLFunction, fragmentFunc fragfunc: MTLFunction) throws -> MTLRenderPipelineState {
                let pdesc = MTLRenderPipelineDescriptor()
                // Set up a descriptor for creating a pipeline state object
                pdesc.label             = "Texturing Pipeline"
                pdesc.vertexFunction    = verfunc
                pdesc.fragmentFunction  = fragfunc
                if let attach = pdesc.colorAttachments[0] {
                        attach.pixelFormat = view.colorPixelFormat
                }
                return try dev.makeRenderPipelineState(descriptor: pdesc)
        }
}

