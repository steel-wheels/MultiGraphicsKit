# Software Components

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





