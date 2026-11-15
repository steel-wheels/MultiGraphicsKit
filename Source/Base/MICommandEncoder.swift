/*
 * @file MICommandEncoder.swift
 * @description Define
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
import MetalKit
import Foundation

public class MIImageCommandEncoder
{
        private var mView:              MTKView
        private var mCurrentSize:       CGSize

        public enum AAPLVertexInputIndex: Int {
                case AAPLVertexInputIndexVertices     = 0
                case AAPLVertexInputIndexViewportSize = 1
        }

        public enum AAPLTextureIndex: Int {
                case AAPLTextureIndexBaseColor = 0
        }

        public init(view: MTKView){
                mView           = view
                mCurrentSize    = CGSize.zero
        }

        public func resize(to newsize: CGSize) -> Bool {
                let result: Bool = mCurrentSize == newsize
                mCurrentSize = newsize
                return result
        }

        public func allocate(pipelineState pstate: MTLRenderPipelineState, commandBuffer cmdbuf: MTLCommandBuffer, imageBuffer imgbuf: MIImageBuffer, texture tex: MTLTexture) throws -> MTLRenderCommandEncoder {
                guard let desc = mView.currentRenderPassDescriptor, let dev = mView.device else {
                        throw MIGraphicsError.nullObject
                }
                let renderEncoder = try cmdbuf.makingRenderCommandEncoder(descriptor: desc)
                renderEncoder.label = "my render encoder"

                // Set the region of the drawable to draw into.
                let viewport = MTLViewport(originX: 0.0, originY: 0.0,
                                           width:  CGFloat(mCurrentSize.width),
                                           height: CGFloat(mCurrentSize.height),
                                           znear: -1.0, zfar: 1.0)
                renderEncoder.setViewport(viewport)
                renderEncoder.setRenderPipelineState(pstate)
                renderEncoder.setVertexBuffer(try imgbuf.buffer(), offset: 0,
                                              index: AAPLVertexInputIndex.AAPLVertexInputIndexVertices.rawValue)

                let viewportSize = vector_uint2(UInt32(mCurrentSize.width), UInt32(mCurrentSize.height))
                let sizebuf = try Vector2u32.makeBuffer(device: dev, vectors: [viewportSize])
                renderEncoder.setVertexBuffer(sizebuf, offset: 0, index: AAPLVertexInputIndex.AAPLVertexInputIndexViewportSize.rawValue)

                // Set the texture object.  The AAPLTextureIndexBaseColor enum value corresponds
                ///  to the 'colorMap' argument in the 'samplingShader' function because its
                //   texture attribute qualifier also uses AAPLTextureIndexBaseColor for its index.
                renderEncoder.setFragmentTexture(tex, index: AAPLTextureIndex.AAPLTextureIndexBaseColor.rawValue)

                // Draw the triangles.
                renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: imgbuf.vertexCount)

                // end of encoding
                renderEncoder.endEncoding()

                return renderEncoder
        }
}

