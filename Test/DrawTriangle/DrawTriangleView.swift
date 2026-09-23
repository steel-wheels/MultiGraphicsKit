//
//  DrawTriangleView.swift
//  DrawTriangle
//
//  Created by Tomoo Hamada on 2026/09/13.
//

import MultiGraphicsKit
import MultiUIKit
import MetalKit

public class DrawTriangleView: MIMetalView
{
        public override func setup(frame frm: CGRect) {
                super.setup(frame: frm)
        }

        public func makeTriangleDataBuffers(device dev: MIMetalDevice, count cnt: UInt) -> Array<MTLBuffer> {
                var buffers: Array<MTLBuffer> = []
                for _ in 0..<cnt {
                        let buf = dev.makeBuffer(length: MemoryLayout<MIVertex>.size, options: .storageModeShared, placementSparsePageSize: .size64)
                        buffers.append(buf)
                }
                return buffers
        }

        /// Creates a new argument table from the renderer's device that stores two arguments.
        public func makeArgumentTable(count cnt: Int) -> MTL4ArgumentTable {
                let desc = MTL4ArgumentTableDescriptor()
                desc.maxBufferBindCount = cnt ;
                return device.makeArgumentTable(descriptor: desc)
        }

        /// Returns a new residency set from the renderer's device.
        public func makeResidencySet() -> MTLResidencySet {
                let desc = MTLResidencySetDescriptor()
                return device.makeResidencySet(descriptor: desc)
        }

        /// Creates new command allocator instances from the renderer's device and returns them in a new array.
        /// - Parameter count: The number of allocators the method creates.
        public func makeCommandAllocators(count cnt: UInt) -> Array<MTL4CommandAllocator> {
                var result: Array<MTL4CommandAllocator> = []
                let dev = self.device
                for _ in  0..<cnt {
                        let allocator = dev.makeCommandAllocator()
                        result.append(allocator)
                }
                return result
        }

        /// Pauses the CPU when the device is rendering a previous frame that needs the resources
        /// that the renderer is about to reuse for a frame.
        ///
        /// The method adds a command that waits for a signal from the command queue that
        /// indicates when the Metal device is done rendering an earlier frame.
        /// This signal means the renderer can safely reuse the resources for that prior frame.
        public func waitOnSharedEvent(sharedEvent event: MTLSharedEvent,
                                      forEarlierFrame framenum: UInt64) {
                let tenMilliseconds: UInt64 = 10
                let beforeTimeout = event.wait(untilSignaledValue: framenum,
                                               timeoutMS: tenMilliseconds)
                if !beforeTimeout {
                        NSLog("No signal from frame \(framenum) to shared event after \(tenMilliseconds) ms");
                }
        }

        /// Configures the viewport for a render pass.
        ///
        /// The method sets the size to the same dimensions as the view's drawable region.
        /// - Parameter renderPassEncoder: An encoder for a render pass.
        public func setViewportSize(size sz: simd_uint2,
                                    forRenderEncoder encoder: MTL4RenderCommandEncoder) {
                let viewPort = MTLViewport(originX: 0.0,
                                           originY: 0.0,
                                           width:   Double(sz.x),
                                           height:  Double(sz.y),
                                           znear:   0.0,
                                           zfar:    1.0)
                encoder.setViewport(viewPort)
        }

        /// Configures the arguments for a render pass.
        ///
        /// - Parameter renderPassEncoder: An encoder for a render pass.
        ///
        /// The draw command in every render pass this app creates needs two arguments:
        /// - The vertex position and color data for a triangle
        /// - The size of the app's current viewport
        ///
        /// The triangle data changes every frame.
        /// The size of the viewport can change, but typically remains the same until a
        /// person changes the size of the app or its window.
        public func setRenderPassArguments(renderPassEncoder encoder: MTL4RenderCommandEncoder,
                                           forFrame framenum: Int,
                                           with argumentTable: MTL4ArgumentTable,
                                           vertexBuffer vbuffer: MTLBuffer,
                                           viewPortSize psize: MTLBuffer) {
                let triangle = configureVertexDataForBuffer(rotationInDegrees: framenum)

        }

        /*
        - (void) setRenderPassArguments:(id<MTL4RenderCommandEncoder>) renderPassEncoder
                               forFrame:(NSUInteger) frameNumber
                                   with:(id<MTL4ArgumentTable>) argumentTable
                           vertexBuffer:(id<MTLBuffer>) vertexBuffer
                           viewPortSize:(id<MTLBuffer>) viewportSizeBuffer
        {
            configureVertexDataForBuffer(frameNumber, vertexBuffer.contents);

            // Add the buffer with the triangle data to the argument table.
            [argumentTable setAddress:vertexBuffer.gpuAddress
                              atIndex:InputBufferIndexForVertexData];

            // Add the buffer with the viewport's size to the argument table.
            [argumentTable setAddress:viewportSizeBuffer.gpuAddress
                              atIndex:InputBufferIndexForViewportSize];

            // Assign the argument table to the encoder.
            [renderPassEncoder setArgumentTable:argumentTable
                                       atStages:MTLRenderStageVertex];
        }*/

}
