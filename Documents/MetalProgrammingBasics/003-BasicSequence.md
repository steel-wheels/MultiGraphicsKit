# Basic sequence

## Overview

This section describes about the basic sequence to execute the vector calculation.

1. Get <i>device object</i> for the application
2. Get <i>command queue</i> for the <i>device object</i>
3. Allocate <i>command encoder</i> for the target function
    1. Load <i>Library</i>
    2. Select <i>function</i> which is defined in the library
    3. Allocate <i>command encoder</i> for the <i>function</i>
4. Set input and output buffers to <i>command encoder</i> 
    1. Make source data for calculation
    2. Allocate input buffers for source data
    3. Allocate output buffer to store result
    4. Set buffers fo <i>command encoder</i>
5. Start calculation by Metal
    1. Commit the <i>command encoder</i> to the command queue
6. Wait until the calculation finished
7. Get the result of calculation

## Sample implementation
