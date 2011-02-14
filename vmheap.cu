#include "vmheap.h"


VMLocalHeap* VMCreateLocalHeap(int heapSizeInBytes)
{
    VMLocalHeap* heap = (VMLocalHeap*)malloc(sizeof(VMLocalHeap));
    heap->data = malloc(heapSizeInBytes);
    heap->heapPointer = 0;
    return heap;
}

void VMDestroyLocalHeap(VMLocalHeap* heap)
{
    free(heap->data);
    free(heap);
}

void* VMLocalHeapAlloc(VMLocalHeap* heap, int size)
{
    void* newData = heap->data;
    heap->heapPointer += size;
    return newData;
}
