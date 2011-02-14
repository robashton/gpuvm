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


void Creating_A_Stack_Initializes_StackData()
{
    VMStack* stack = VMCreateStack(1024, 100);

    assert_is_true(stack->currentItem == -1, "Initial stack item is not a null ptr");
    assert_is_true(stack->maxitems == 100, "Stack Max items was not initialized");

    VMDestroyStack(stack);
}


void Allocating_An_Item_On_The_Stack_Increases_Stack_Pointer()
{
    VMStack* stack = VMCreateStack(1024, 100);

    VMStackAlloc(stack, sizeof(int));
    VMStackAlloc(stack, sizeof(int));

    assert_is_true(stack->currentItem == 1, "Current stack item after allocation is not correct");
    assert_is_true(stack->items[1] == 4, "Top item does not point at correct location in stack");
    assert_is_true(stack->items[0] == 0, "Old item does not point at first location in the stack");

    VMDestroyStack(stack);
}

void Freeing_An_Item_Off_The_Stack_Decreases_Stack_Pointer()
{
    VMStack* stack = VMCreateStack(1024, 100);

    VMStackAlloc(stack, sizeof(int));
    VMStackAlloc(stack, sizeof(long));

    VMStackFree(stack);
    VMStackFree(stack);

    assert_is_true(stack->currentItem == -1, "Current stack item after freeing is not correct");

    VMDestroyStack(stack);
}


void Adding_Two_Numbers_Places_Result_On_Stack()
{
    // A context
    VMContext* context = VMCreateContext(1);

    // Ordinarily these would come from the heap ofc
    int numberOne = 2;
    int numberTwo = 3;

    // This is a set of instructions that will push 2 numbers onto the stack and call 'add'
    context->methods[0].instructionCount = 3;
    context->methods[0].instructions = (VMInstruction*)malloc(sizeof(VMInstruction)*3);
    context->methods[0].instructions[0].type = PUSH;
    context->methods[0].instructions[0].arg.argType = INT;
    context->methods[0].instructions[0].arg.data = &numberOne;
    context->methods[0].instructions[1].type = PUSH;
    context->methods[0].instructions[1].arg.argType = INT;
    context->methods[0].instructions[1].arg.data = &numberTwo;
    context->methods[0].instructions[2].type = ADD;
    context->methods[0].instructions[2].arg.data = 0;

//    VMExecutionContext context;
    VMExecuteMethod(context, 0);


 //   VMDestroyLocalHeap(heap);
    VMDestroyContext(context);


}

int main()
{
    A_New_Context_Has_Prescribed_Number_Of_Methods();
    Allocating_Data_On_The_Heap_Increases_Heap_Pointer_To_Next_Available_Slot();
    Allocating_Data_On_The_Heap_Returns_Pointer_To_Data_On_The_Heap();
    Creating_A_Stack_Initializes_StackData();
    Allocating_An_Item_On_The_Stack_Increases_Stack_Pointer();
    Freeing_An_Item_Off_The_Stack_Decreases_Stack_Pointer();

//   Adding_Two_Numbers_Places_Result_On_Stack();
    return 0;
}
