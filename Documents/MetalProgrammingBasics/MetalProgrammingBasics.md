# Metal programming basics

## Introduction
This document describes about basics of the Apple's Metal GPU processor programming.

### Copyright

This document is distributed under [GNU Free Documentation License](https://www.gnu.org/licenses/fdl-1.3.en.html).


## Fundamentals

### Software components
##### Software Components

This section describes about software components for Metal programming.

##### Device: [MTLDevice]
Resource for Metal. Each application has it's own device controller.

##### Command Queue: [MTLCommandQueue]
The queue of command buffers to be excuted on the device.

##### Command buffer: [MTLCommandBuffer]
The container of multiple command encoder.

##### Command Encoder: [MTLComputeCommandEncoder]
encode the pipeline state and buffer to compute it on Metal

##### Texture [MTLTexture]
* Use the [MTKTextureLoader] class to create a Metal texture from existing image data.



### Basic Sequence
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

```




## Tips

### Programming Tips
# Programming Tips

## macOS/iOS

## Coding by Swift

### <code>import</code>
To use <code>MTL*</code> class, import following frameworks.

```
import Metal            // Data processing by Metal
import MetalKit         // User interface by Metal
```




## Reference

### Metal overview
* [Apple Developer Metal]: Apple Developer Metal
* [Metal Shading Language Specification]: Metal Shading Language Specification, Version 4.1

### Software components
* [MTLCommandBuffer]: Records a sequence of GPU commands.
* [MTLCommandEncoder]: Encoder a
  * [MTLComputeCommandEncoder]: Encodes computation dispatches, resource copying commands, and acceleration structure building commands for a single pass into a command buffer. 
* [MTLCommandQueue]: An abstraction representing a command queue that you use commit and synchronize command buffers and to perform other GPU operations.
* [MTLComputePipelineState]: An interface that represents a GPU pipeline configuration for running kernels in a compute pass.
* [MTLDevice]: The main Metal interface to a GPU that apps use to draw graphics and run computations in parallel.
* [MTLFunction]: A interface that represents a public shader function in a Metal library.
* [MTLLibrary]: A collection of Metal shader functions.

### Sample code from Apple
* [Metal sample code library](https://developer.apple.com/documentation/metal/metal-sample-code-library): List of following sample applications
* [Creating and sampling textures](https://developer.apple.com/documentation/metal/creating-and-sampling-textures): Load image data into a texture and apply it to a quadrangle.

### Sample code
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


