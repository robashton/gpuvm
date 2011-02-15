
void Allocating_Data_On_The_Heap_Increases_Heap_Pointer_To_Next_Available_Slot()
{
    VMHeap* heap = VMCreateLocalHeap(1024);
    VMLocalHeapAlloc(heap, 12);

    assert_is_true(heap->heapPointer == 12, "Heap Pointer was not incremented");

    VMDestroyLocalHeap(heap);
}

void Allocating_Data_On_The_Heap_Returns_Pointer_To_Data_On_The_Heap()
{
    VMHeap* heap = VMCreateLocalHeap(1024);
    void* freeData = heap->data;
    void* allocedData = VMLocalHeapAlloc(heap, 12);

    assert_is_true(freeData == allocedData, "Pointer returned from heap alloc was not pointer to new data");

    VMDestroyLocalHeap(heap);
}

void test_heap()
{
    Allocating_Data_On_The_Heap_Increases_Heap_Pointer_To_Next_Available_Slot();
    Allocating_Data_On_The_Heap_Returns_Pointer_To_Data_On_The_Heap();
}
