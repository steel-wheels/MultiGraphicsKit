# Introduction

This document describes about basics of the Apple's Metal GPU processor programming.

# Copyright

This document is distributed under [GNU Free Documentation License](https://www.gnu.org/licenses/fdl-1.3.en.html).# Software Components

This section describes about software components for Metal programming.

## Device:
* Resource for Metal. Each application has it's own device controller.
* class: [MTLDevice]
* Each device have a command queue.

## Command Queue:
* The queue of command buffers to be excuted on the device.
* class: [MTL4CommandQueue]

## Command buffer:
* The container of multiple command encoder.
* class: [MTL4CommandBuffer]

## Command Encoder: 
* encode the pipeline state and buffer to compute it on Metal
* class: [MTL4ComputeCommandEncoder]





# Basic sequence

## Overview

This section describes about the basic sequence to execute the vector calculation.

1. Get <i>device object</i> for the application
2. Get <i>command queue</i> for the <i>device object</i>
3. Allocate shader for the target function
    1. Load <i>Library</i>
    2. Select <i>function</i> which is defined in the library
    3. Allocate shader for the <i>function</i>
4. b

## Sample implementation
# References

## Metal overview
* [Apple Developer: Metal](https://developer.apple.com/documentation/metal)

## Software components
* [MTL4CommandBuffer]: Records a sequence of GPU commands.
* [MTL4ComputeCommandEncoder]: Encodes computation dispatches, resource copying commands, and acceleration structure building commands for a single pass into a command buffer. 
* [MTL4CommandQueue]: An abstraction representing a command queue that you use commit and synchronize command buffers and to perform other GPU operations.
* [MTLComputePipelineState]: An interface that represents a GPU pipeline configuration for running kernels in a compute pass.
* [MTLDevice]: The main Metal interface to a GPU that apps use to draw graphics and run computations in parallel.
* [MTLFunction]: A interface that represents a public shader function in a Metal library.
* [MTLLibrary]: A collection of Metal shader functions.

## Sample code
* [Using Metal to draw a view’s contents](https://developer.apple.com/documentation/metal/using-metal-to-draw-a-view's-contents)
* [Drawing a triangle with Metal 4](https://developer.apple.com/documentation/metal/drawing-a-triangle-with-metal-4)
* [Metal を使って10万個のパーティクルを描画しよう (Japanese)](https://qiita.com/naru-jpn/items/9f4f1624495f3e72d6f9)

[MTL4CommandBuffer]: https://developer.apple.com/documentation/metal/mtl4commandbuffer
[MTL4ComputeCommandEncoder]: https://developer.apple.com/documentation/metal/mtl4computecommandencoder
[MTLComputePipelineState]: https://developer.apple.com/documentation/metal/mtlcomputepipelinestate
[MTL4CommandQueue]: https://developer.apple.com/documentation/metal/mtl4commandqueue
[MTLDevice]: https://developer.apple.com/documentation/metal/mtldevice
[MTLFunction]: https://developer.apple.com/documentation/metal/mtlfunction
[MTLLibrary]: https://developer.apple.com/documentation/metal/mtllibrary
