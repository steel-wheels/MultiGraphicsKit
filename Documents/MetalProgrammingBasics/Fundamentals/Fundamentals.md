## Fundamentals

### Data structure

#### Vertex



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
@code_begin@

@code_end@



