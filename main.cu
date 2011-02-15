#include <stdio.h>
#include <stdlib.h>
#include "gpuvm.h"
#include "testing.h"


// TODO:
// Stack implementation                                                         [x]
// Heap implementation                                                          [x]
// Basic instruction processor                                                  [x]
// Method invocation                                                            [ ]
// Add primitive type 'float'                                                   [x]
// Add primitive type 'long'                                                    [ ]
// Add primitive type 'char'                                                    [ ]
// Add primitive type 'string'                                                  [ ]
// Add boot-strap code for initialising 'environment' (stack per thread etc)    [ ]
// Create wrapped malloc/free macros for use with GPU/CPU switch-over           [ ]
// Convert all functions to be __device__ and __global__ compatible             [ ]
// 'Actor' context (variable table pointing at global heap state)               [ ]
// Define a binary program 'format'                                             [ ]
// Write code to serialize/de-serialize into that format                        [ ]
// Define a DSL for actor based interaction                                     [ ]
// Create a compiler to compile DSL files                                       [ ]
// Create a linker to link DSL files into binary program format                 [ ]

/// THIS IS A PROBLEM FOR ANOTHER TIME
// Local variables? Global variables? How to avoid garbage collection?          [ ]

#ifndef TESTINGMODE

int main()
{
    printf("This will be the compiler/runtime utility/thingy, for now it's a blank space");
    return 0;
}

#endif
