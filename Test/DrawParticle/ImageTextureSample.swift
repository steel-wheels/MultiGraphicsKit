/*
 * @file ImageTextureSample.swift
 * @description Sample program to draw image texture
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiGraphicsKit
import MultiDataKit
import MultiUIKit
import Metal
import AppKit
import MetalKit
import Foundation

public class ImageTextureDrawer
{
        private var mView:              MTKView
        private var mDevice:            MTLDevice
        private var mTexture:           MTLTexture?
        private var mVertexNum:         Int
        private var mVertexBuffer:      MTLBuffer?
        private var mPipelineState:     MTLRenderPipelineState?
        private var mViewportSize:      vector_uint2

        public enum AAPLVertexInputIndex: Int {
                case AAPLVertexInputIndexVertices     = 0
                case AAPLVertexInputIndexViewportSize = 1
        }

        public enum AAPLTextureIndex: Int {
                case AAPLTextureIndexBaseColor = 0
        }

        public struct MetalFunctions {
                public var vertexFunction:    MTLFunction
                public var fragmentFunction:   MTLFunction
                public init(vertexFunction: MTLFunction, fragmentFunction: MTLFunction) {
                        self.vertexFunction   = vertexFunction
                        self.fragmentFunction = fragmentFunction
                }
        }

        public init(view: MTKView, device: MTLDevice) {
                self.mView              = view
                self.mDevice            = device
                self.mTexture           = nil
                self.mVertexNum         = 0
                self.mVertexBuffer      = nil
                self.mPipelineState     = nil
                self.mViewportSize      = vector_uint2(0, 0)
        }

        public func setup() {
                do {
                        NSLog("setup: ImageTextureDrawer")
                        mTexture        = try allocateTexture()
                        mVertexBuffer   = try allocateBuffer()
                        let funcs       = try setupLibrary()
                        mPipelineState  = try allocateRenderPipelineState(functions: funcs)
                } catch {
                        NSLog("[Error] Failed to setup")
                }
        }

        private func allocateTexture() throws -> MTLTexture {
                guard let img = ImageTextureDrawer.loadImage() else {
                        NSLog("[Error] Failed to load image")
                        throw MIError.processError(message: "[Error] Failed to allocate image")
                }
                return try newTexture(image: img, options: nil)
        }

        private func newTexture(image img: MIImage, options opts: [MTKTextureLoader.Option : Any]?) throws -> MTLTexture {
                guard let cgimg = img.cgImage else {
                        throw MIError.processError(message: "[Error] Failed to convert image")
                }
                let loader = MTKTextureLoader(device: mDevice)
                return try loader.newTexture(cgImage: cgimg, options: opts)
        }

        private func allocateBuffer() throws -> MTLBuffer {
                // Set up a simple MTLBuffer with vertices which include texture coordinates
                let quadVertices: Array<Vertex2f> = [
                        // Pixel positions, Texture coordinates
                        Vertex2f(position: SIMD2(+250, -250), textureCoordinate: SIMD2(1.0, 1.0)),
                        Vertex2f(position: SIMD2(-250, -250), textureCoordinate: SIMD2(0.0, 1.0)),
                        Vertex2f(position: SIMD2(-250, +250), textureCoordinate: SIMD2(0.0, 0.0)),
                        Vertex2f(position: SIMD2(+250, -250), textureCoordinate: SIMD2(1.0, 1.0)),
                        Vertex2f(position: SIMD2(-250, +250), textureCoordinate: SIMD2(0.0, 0.0)),
                        Vertex2f(position: SIMD2(+250, +250), textureCoordinate: SIMD2(1.0, 0.0)),
                ]
                mVertexNum = quadVertices.count
                return try Vertex2f.makeBuffer(device: mDevice, vertexes: quadVertices)
        }

        public func setupLibrary() throws -> MetalFunctions {
                // Load the shaders from the default library
                let lib = try mDevice.loadLibrary()
                let vertexFunction = try lib.makeFunction(builtIn: .vertexShader)
                let shaderFunction = try lib.makeFunction(builtIn: .samplingShader)
                return MetalFunctions(vertexFunction: vertexFunction, fragmentFunction: shaderFunction)
        }

        private func allocateRenderPipelineState(functions funcs: MetalFunctions) throws -> MTLRenderPipelineState {
                let pdesc = MTLRenderPipelineDescriptor()
                // Set up a descriptor for creating a pipeline state object
                pdesc.label             = "Texturing Pipeline"
                pdesc.vertexFunction    = funcs.vertexFunction
                pdesc.fragmentFunction  = funcs.fragmentFunction
                if let attach = pdesc.colorAttachments[0] {
                        attach.pixelFormat = mView.colorPixelFormat
                }
                return try mDevice.makeRenderPipelineState(descriptor: pdesc)
        }

        public func setViewportSize(size: CGSize) {
                let width  = UInt32(size.width )
                let height = UInt32(size.height)
                NSLog("setViewportSize(\(width), \(height))")
                mViewportSize.x = width
                mViewportSize.y = height
        }

        public func draw() {
                guard let pstate = mPipelineState, let vertexBuffer = mVertexBuffer,
                      let texture = mTexture, let drawable = mView.currentDrawable else {
                        NSLog("[Error] No pipeline state, buffer")
                        return
                }
                do {
                        // Create a new command buffer for each render pass to the current drawable
                        let cmdq   = try mDevice.makingCommandQueue()
                        let cmdbuf = try cmdq.makingCommandBuffer()
                        cmdbuf.label = "MyCommand"

                        // Obtain a renderPassDescriptor generated from the view's drawable textures
                        guard let renderPassDescriptor = mView.currentRenderPassDescriptor else {
                                NSLog("[Error] no render pass descriptor")
                                return
                        }
                        let renderEncoder = try cmdbuf.makingRenderCommandEncoder(descriptor: renderPassDescriptor)
                        renderEncoder.label = "my render encoder"

                        // Set the region of the drawable to draw into.
                        let viewport = MTLViewport(originX: 0.0, originY: 0.0,
                                                   width:  CGFloat(mViewportSize.x),
                                                   height: CGFloat(mViewportSize.y),
                                                   znear: -1.0, zfar: 1.0)
                        renderEncoder.setViewport(viewport)
                        renderEncoder.setRenderPipelineState(pstate)
                        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0,
                                                      index: AAPLVertexInputIndex.AAPLVertexInputIndexVertices.rawValue)

                        let sizebuf = try Vector2u32.makeBuffer(device: mDevice, vectors: [mViewportSize])
                        renderEncoder.setVertexBuffer(sizebuf, offset: 0, index: AAPLVertexInputIndex.AAPLVertexInputIndexViewportSize.rawValue)

                        // Set the texture object.  The AAPLTextureIndexBaseColor enum value corresponds
                        ///  to the 'colorMap' argument in the 'samplingShader' function because its
                        //   texture attribute qualifier also uses AAPLTextureIndexBaseColor for its index.
                        renderEncoder.setFragmentTexture(texture, index: AAPLTextureIndex.AAPLTextureIndexBaseColor.rawValue)

                        // Draw the triangles.
                        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mVertexNum)

                        // end of encoding
                        renderEncoder.endEncoding()

                        // Schedule a present once the framebuffer is complete using the current drawable
                        cmdbuf.present(drawable)

                        // Finalize rendering here & push the command buffer to the GPU
                        cmdbuf.commit()
                } catch {
                        NSLog("[Error] Failed to draw")
                }
        }

        private static func loadImage() -> MIImage?
        {
                guard let resdir = FileManager.default.resourceDirectory else {
                        NSLog("No resource directory")
                        return nil
                }
                let filepath = resdir.appendingPathComponent("Images/steel-wheels.png")
                if let img = MIImage(contentsOf: filepath) {
                        return img
                } else {
                        NSLog("Failed to load image from \(filepath.path())")
                        return nil
                }
        }
}
