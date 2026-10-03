# Introduction

# Software Components

## Device
* Resource for Metal. Each application has it's own device controller.

## Command Queue
* The queue of command buffers to be excuted on the device.

## Command buffer
* The container of multiple command encoder.

## Command Encoder
* encode the pipeline state and buffer to compute it on Metal

# References
## Metal overview
* [Apple Developer: Metal](https://developer.apple.com/documentation/metal)

## Metak sample code
* [Using Metal to draw a view’s contents](https://developer.apple.com/documentation/metal/using-metal-to-draw-a-view's-contents)
* [Drawing a triangle with Metal 4](https://developer.apple.com/documentation/metal/drawing-a-triangle-with-metal-4)
* [Metal を使って10万個のパーティクルを描画しよう (Japanese)](https://qiita.com/naru-jpn/items/9f4f1624495f3e72d6f9)



# References

## Classes for Metal

* [MTL4CommandBuffer](https://developer.apple.com/documentation/metal/mtl4commandbuffer): Records a sequence of GPU commands.
* [MTL4ComputeCommandEncoder](https://developer.apple.com/documentation/metal/mtl4computecommandencoder): Encodes computation dispatches, resource copying commands, and acceleration structure building commands for a single pass into a command buffer. 
* [MTL4CommandQueue](https://developer.apple.com/documentation/metal/mtl4commandqueue): An abstraction representing a command queue that you use commit and synchronize command buffers and to perform other GPU operations.
* [MTLDevice](https://developer.apple.com/documentation/metal/mtldevice): The main Metal interface to a GPU that apps use to draw graphics and run computations in parallel.
* [MTLLibrary](MTLLibrary): A collection of Metal shader functions.

[MTLLibrary]: https://developer.apple.com/documentation/metal/mtllibrary
