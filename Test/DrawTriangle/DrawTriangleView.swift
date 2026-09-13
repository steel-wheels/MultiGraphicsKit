//
//  DrawTriangleView.swift
//  DrawTriangle
//
//  Created by Tomoo Hamada on 2026/09/13.
//

import MultiGraphicsKit
import MultiUIKit
import MetalKit

open class DrawTriangleView: MIGraphicsView
{
        public override func setup(frame frm: CGRect) {
                NSLog("setup DrawTriangleView")
                super.setup(frame: frm)
                self.backgroundColor = MIColor.blue

                super.setNeedsDisplay(true)
        }

        public override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
                NSLog("\(#file) drawableSizeWillChange")
        }
}

/*
 import Cocoa
 import MetalKit

 class ViewController: NSViewController, MTKViewDelegate {

     var device: MTLDevice!
     var commandQueue: MTLCommandQueue!
     var pipelineState: MTLRenderPipelineState!
     var vertexBuffer: MTLBuffer!

     override func viewDidLoad() {
         super.viewDidLoad()
...
         // コマンドキュー
         commandQueue = device.makeCommandQueue()

         // シェーダのロード
         let library = device.makeDefaultLibrary()
         let vertexFunc = library?.makeFunction(name: "vertex_main")
         let fragmentFunc = library?.makeFunction(name: "fragment_main")

         // パイプライン
         let pipelineDesc = MTLRenderPipelineDescriptor()
         pipelineDesc.vertexFunction = vertexFunc
         pipelineDesc.fragmentFunction = fragmentFunc
         pipelineDesc.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat

         pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDesc)

         // 矩形の頂点（2つの三角形）
         let vertices: [float2] = [
             float2(-0.5,  0.5),
             float2(-0.5, -0.5),
             float2( 0.5, -0.5),

             float2(-0.5,  0.5),
             float2( 0.5, -0.5),
             float2( 0.5,  0.5)
         ]

         vertexBuffer = device.makeBuffer(bytes: vertices,
                                          length: MemoryLayout<float2>.size * vertices.count,
                                          options: [])
     }

     // 描画ループ
     func draw(in view: MTKView) {
         guard let drawable = view.currentDrawable,
               let descriptor = view.currentRenderPassDescriptor else { return }

         let commandBuffer = commandQueue.makeCommandBuffer()
         let encoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)

         encoder?.setRenderPipelineState(pipelineState)
         encoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
         encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)

         encoder?.endEncoding()
         commandBuffer?.present(drawable)
         commandBuffer?.commit()
     }
 }

 */
