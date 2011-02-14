#include <stdio.h>
#include <stdlib.h>
#include "gpuvm.h"
#include "testing.h"

void A_New_Context_Has_Prescribed_Number_Of_Methods()
{
    VMContext* context = VMCreateContext(1);
    assert_is_true(context->methodCount == 1, "Context had incorrect number of methods");
    VMDestroyContext(context);
}

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

void Adding_Two_Numbers_Places_Result_On_Stack()
{
    VMContext* context = VMCreateContext(1);
    VMInstruction instructions[] = {};
 //   context->methods[0].
}

int main()
{
    A_New_Context_Has_Prescribed_Number_Of_Methods();
    Allocating_Data_On_The_Heap_Increases_Heap_Pointer_To_Next_Available_Slot();
    Allocating_Data_On_The_Heap_Returns_Pointer_To_Data_On_The_Heap();

 //   Adding_Two_Numbers_Places_Result_On_Stack();
    return 0;
}
