#ifndef VMHEAP_H
#define VMHEAP_H

// This is a local append-only heap
// This VM allows local variable declaration and will append to this until there is no more room left (error!)
// There will be one of these per actor, and when being passed down a method call chain will be append-only
// and un-append as traversing back up again
typedef struct VMLocalHeap
{
    void* data;
    int heapPointer;
} VMHeap;

// Creates a heap ready for use, with a maximum size in bytes
VMLocalHeap* VMCreateLocalHeap(int heapSizeInBytes);

// Destroys a heap and any allocated data
void VMDestroyLocalHeap(VMLocalHeap* heap);

// Allocates data on the heap and increments the heap pointer
void* VMLocalHeapAlloc(VMLocalHeap* heap, int size);

#endif
