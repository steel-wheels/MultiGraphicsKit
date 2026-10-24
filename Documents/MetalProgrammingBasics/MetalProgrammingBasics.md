# Introduction

This document describes about basics of the Apple's Metal GPU processor programming.

# Copyright

This document is distributed under [GNU Free Documentation License](https://www.gnu.org/licenses/fdl-1.3.en.html).

# Software Components

This section describes about software components for Metal programming.

## Device: [MTLDevice]
Resource for Metal. Each application has it's own device controller.

## Command Queue: [MTLCommandQueue]
The queue of command buffers to be excuted on the device.

## Command buffer: [MTLCommandBuffer]
The container of multiple command encoder.

## Command Encoder: [MTLComputeCommandEncoder]
encode the pipeline state and buffer to compute it on Metal

## Texture [MTLTexture]
* Use the [MTKTextureLoader] class to create a Metal texture from existing image data.



# Basic sequence

## Overview

This section describes about the basic sequence to execute the vector calculation.

1. Get <i>device object</i> for the application
1. Allocate <i>pipeline state</i> to execute the <i>kernel function</i> on the device. 
1. Get <i>command queue</i> for the <i>device object</i>
1. Allocate <i>command buffer</i> from <i>command queue</i>
1. Allocate <i>command encoder</i> from <i>command buffer</i>.
1. Allocate input and output data buffer on the device.
1. Register input and output buffers to <i>command encoder</i>.
1. Register the <i>pipeline state</i> to <i>command encoder</i>
1. Set thread grouping information to <i>command encoder</i>.
1. Execute the thread by commiting the <i>command buffer</i>.

## Sample implementation
```
/*
 * @file VectorAddSample.swift
 * @description Sample program for vector add operation
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiGraphicsKit
import MultiDataKit
import Metal
import Foundation

public func vectorAddSample(device dev: MTLDevice) -> Bool
{
        // make source data
        let POINT_NUM            = 8
        var src0: Array<CGPoint> = []
        var src1: Array<CGPoint> = []
        for i in 0..<POINT_NUM {
                let x: CGFloat = CGFloat(i) * 2.0
                let y: CGFloat = x + 1.0
                src0.append(CGPoint(x: x,   y: y))
                src1.append(CGPoint(x: 1.0, y: 1.0))
        }

        do {
                let lib     = try dev.loadLibrary()
                let addfunc = try lib.makeFunction(builtIn: .addVector2f)
                let pstate  = try dev.makeComputePipelineState(function: addfunc)

                let cmdq   = try dev.makingCommandQueue()
                let cmdbuf = try cmdq.makingCommandBuffer()
                let cmdenc = try cmdbuf.makingComputeCommandEncoder()

                // allocate buffers
                let inbuf0  = try Vector2f.makeBuffer(device: dev, points: src0)
                let inbuf1  = try Vector2f.makeBuffer(device: dev, points: src1)
                let outbuf  = try Vector2f.makeUninitializedBuffer(device: dev, count: POINT_NUM)

                NSLog("inbuf0: \(String(inbuf0.gpuAddress, radix: 16))")
                NSLog("inbuf1: \(String(inbuf1.gpuAddress, radix: 16))")
                NSLog("outbuf: \(String(outbuf.gpuAddress, radix: 16))")

                cmdenc.setBuffer(outbuf, offset: 0, index: 0)
                cmdenc.setBuffer(inbuf0, offset: 0, index: 1)
                cmdenc.setBuffer(inbuf1, offset: 0, index: 2)
                cmdenc.setComputePipelineState(pstate)

                let threadsPerGrid        = MTLSize(width: POINT_NUM, height: 1, depth: 1)
                let threadsPerThreadgroup = MTLSize(width: 1, height: 1, depth: 1)
                cmdenc.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
                cmdenc.endEncoding()

                cmdbuf.commit()
                cmdbuf.waitUntilCompleted()

                NSLog("- print result")
                putBuffer(name: "inbuf0", buffer: inbuf0)
                putBuffer(name: "inbuf1", buffer: inbuf1)
                putBuffer(name: "outbuf", buffer: outbuf)

                return true
        } catch {
                NSLog("Failed to execute")
                return false
        }
}

private func putBuffer(name nm: String, buffer buf: MTLBuffer) {
        let pts = Vector2f.toPoints(buffer: buf)
        NSLog("-- \(nm).count = \(pts.count)")
        for pt in pts {
                NSLog("    -> \(pt.x), \(pt.y)")
        }
}


```


# Basic sequence to draw texture

## Overview

This section describes about the basic sequence to draw the texture generated from PNG file.
The referenced document is [Using MTLTexture](https://qiita.com/edo_m18/items/6e44308d1b865e614f7c) (Japanese).

1. 画像ファイルからMTLTextureを生成する
    1. MTLTextureDescriptorオブジェクトを生成する
    1. MTLTexutureオブジェクトを生成する
1. MTLRenderPassDescriptorオブジェクトを生成する
    1. colorAttachmentのテクスチャプロパティに、生成したテクスチャオブジェクトを指定する
1. MTLSamplerStateオブジェクトを生成する（※1）
1. MTLSamplerDescriptorオブジェクトを生成する
1. MTLRenderCommandEncoderにテクスチャ情報をセットする

## Sample implementation
```
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
import Foundation

public func imageTextureSample(device dev: MTLDevice) -> Bool
{
        /* load PNG image */
        guard let img = loadImage() else {
                return false
        }
        do {
                let lib     = try dev.loadLibrary()

                let cmdq   = try dev.makingCommandQueue()
                let cmdbuf = try cmdq.makingCommandBuffer()

                let texture = try dev.makingTexture(image: img)

                let renderdesc   = MTLRenderPassDescriptor()
                guard let attach = renderdesc.colorAttachments[0] else {
                        NSLog("[Error] No attachement")
                        return false
                }
                attach.texture          = texture
                attach.clearColor       = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
                attach.storeAction      = .store

                let samplerdesc = MTLSamplerDescriptor()
                samplerdesc.minFilter    = .nearest
                samplerdesc.magFilter    = .linear
                samplerdesc.sAddressMode = .repeat
                samplerdesc.tAddressMode = .repeat
                let sampler = try dev.makingSamplerState(descriptor: samplerdesc)

                let cmdenc = cmdbuf.makeRenderCommandEncoder(descriptor: renderdesc)

        } catch {
                NSLog("Failed to execute")
                return false
        }

        return true
}

private func loadImage() -> MIImage?
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


```


# Metal library

```
//
//  vectorFunctions.metal
//  MultiGraphicsKit
//
//  Created by Steel Wheels Project on 2026/09/18.
//

#include <metal_stdlib>
#include "MultiGraphicsKit/MIGraphicsType.h"

using namespace metal;

[[kernel]] void
addVector2f(
            device float2 *             out [[buffer(0)]],
            const device float2 *       inA [[buffer(1)]],
            const device float2 *       inB [[buffer(2)]],
            uint id [[thread_position_in_grid]])
{
        out[id] = inA[id] + inB[id];
}

```

# Programming Tips

## macOS/iOS

## Coding by Swift

### <code>import</code>
To use <code>MTL*</code> class, import following frameworks.

<pre>
import Metal            // Data processing by Metal
import MetalKit         // User interface by Metal
</pre>

# References

## Metal overview
* [Apple Developer Metal]: Apple Developer Metal
* [Metal Shading Language Specification]: Metal Shading Language Specification, Version 4.1

## Software components
* [MTLCommandBuffer]: Records a sequence of GPU commands.
* [MTLCommandEncoder]: Encoder a
  * [MTLComputeCommandEncoder]: Encodes computation dispatches, resource copying commands, and acceleration structure building commands for a single pass into a command buffer. 
* [MTLCommandQueue]: An abstraction representing a command queue that you use commit and synchronize command buffers and to perform other GPU operations.
* [MTLComputePipelineState]: An interface that represents a GPU pipeline configuration for running kernels in a compute pass.
* [MTLDevice]: The main Metal interface to a GPU that apps use to draw graphics and run computations in parallel.
* [MTLFunction]: A interface that represents a public shader function in a Metal library.
* [MTLLibrary]: A collection of Metal shader functions.

## Sample code from Apple
* [Metal sample code library](https://developer.apple.com/documentation/metal/metal-sample-code-library): List of following sample applications
* [Creating and sampling textures](https://developer.apple.com/documentation/metal/creating-and-sampling-textures): Load image data into a texture and apply it to a quadrangle.

## Sample code
* [Using Metal to draw a view’s contents](https://developer.apple.com/documentation/metal/using-metal-to-draw-a-view's-contents)
* [Drawing a triangle with Metal 4](https://developer.apple.com/documentation/metal/drawing-a-triangle-with-metal-4)
* [Metal を使って10万個のパーティクルを描画しよう (Japanese)](https://qiita.com/naru-jpn/items/9f4f1624495f3e72d6f9)
* [iOS: MetalでGPUコンピューティング (1) 最小限のコードの記述と特性の把握](https://qiita.com/yuky_az/items/ece9b64befc635e89f1a)
* [[Metal] テクスチャ（MTLTexture）を使う](https://qiita.com/edo_m18/items/6e44308d1b865e614f7c) (Japanese)
* [Metalで画面を塗るだけのコードが分からなかった話](https://zenn.dev/sakiyamak/articles/metal-01-clear-screen) (Japanese)

[Apple Developer Metal]: https://developer.apple.com/documentation/metal
[Metal Shading Language Specification]: https://developer.apple.com/metal/Metal-Shading-Language-Specification.pdf 

[MTLComputeCommandBuffer]: https://developer.apple.com/documentation/metal/mtlcomputecommandencoder
[MTLCommandBuffer]: https://developer.apple.com/documentation/metal/mtlcommandbuffer
[MTLComputeCommandEncoder]: https://developer.apple.com/documentation/metal/mtlcomputecommandencoder
[MTLCommandEncoder]: https://developer.apple.com/documentation/metal/mtlcommandencoder
[MTLComputePipelineState]: https://developer.apple.com/documentation/metal/mtlcomputepipelinestate
[MTLCommandQueue]: https://developer.apple.com/jp/documentation/metal/mtlcommandqueue
[MTLDevice]: https://developer.apple.com/documentation/metal/mtldevice
[MTLFunction]: https://developer.apple.com/documentation/metal/mtlfunction
[MTLLibrary]: https://developer.apple.com/documentation/metal/mtllibrary
[MTKTextureLoader]: https://developer.apple.com/documentation/metalkit/mtktextureloader
