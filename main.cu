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

    VMStackAlloc(stack, INT);
    VMStackAlloc(stack, INT);

    assert_is_true(stack->currentItem == 1, "Current stack item after allocation is not correct");
    assert_is_true(stack->items[1].data == (void*)(stack->data + 4), "Top item does not point at correct location in stack");
    assert_is_true(stack->items[0].data == (void*)stack->data, "Old item does not point at first location in the stack");

    VMDestroyStack(stack);
}

void Freeing_An_Item_Off_The_Stack_Decreases_Stack_Pointer()
{
    VMStack* stack = VMCreateStack(1024, 100);

    VMStackAlloc(stack, INT);
    VMStackAlloc(stack, INT);

    VMStackFree(stack);
    VMStackFree(stack);

    assert_is_true(stack->currentItem == -1, "Current stack item after freeing is not correct");

    VMDestroyStack(stack);
}

void Allocating_A_Primitive_On_The_Stack_Copies_Data_Into_The_Stack()
{
    VMStack* stack = VMCreateStack(1024, 100);
    int inputData = 5;
    VMPrimitive input;
    input.argType = INT;
    input.data = &inputData;

    VMStackPush(stack, &input);

    VMPrimitive* top = VMStackPeek(stack);

    int* outputData = (int*)top->data;

    assert_is_true(*outputData == inputData, "Correct data was not present on the stack after pushing");

}

void Popping_A_Primitive_Off_The_Stack_Copies_Data_Into_The_Output()
{
    VMStack* stack = VMCreateStack(1024, 100);
    int inputData = 5;
    int outputData = 1;
    VMPrimitive input;
    VMPrimitive output;
    input.argType = INT;
    output.argType = INT;
    input.data = &inputData;
    output.data = &outputData;


    VMStackPush(stack, &input);
    VMStackPop(stack, &output);

    assert_is_true(inputData == outputData, "After pushing and popping data into the stack, the output was corrupt");

}

void OpCode_Push_Pushes_The_Argument_Onto_The_Provided_Stack()
{
    VMContext* context = VMCreateContext(1);
    VMStack* stack = VMCreateStack(1024, 100);

    // Basically, we're assembling a context
    // With a single method, with a single instruction, to push 10 onto the stack
    VMMethod method;
    int inputData = 10;
    VMInstruction instruction;
    instruction.arg.argType = INT;
    instruction.arg.data = (void*)&inputData;
    instruction.type = PUSH;
    method.instructionCount = 1;
    method.instructions = &instruction;
    context->methodCount = 1;
    context->methods = &method;

    VMExecuteMethod(context, stack, 0);

    VMPrimitive* stackItem = VMStackPeek(stack);
    int* stackItemData = (int*)stackItem->data;
    assert_is_true(*stackItemData == 10, "Op code push did not push the requested argument onto the stack");

}

void OpCode_Pop_Pops_The_Next_Item_Off_The_Provided_Stack()
{
    VMStack* stack = VMCreateStack(1024, 100);
    VMContext* context = VMCreateContext(1);
    VMStackAlloc(stack, INT);

    // So, context that contains a method
    // that contains a single instruction to pop the item off the stack
    VMMethod method;
    VMInstruction instruction;
    instruction.type = POP;
    method.instructionCount = 1;
    method.instructions = &instruction;
    context->methodCount = 1;
    context->methods = &method;

    VMExecuteMethod(context, stack, 0);

    assert_is_true(stack->currentItem == -1, "Opcode Pop did not pop the top item off the stack");
}

void OpCode_Add_Adds_The_Two_Numbers_On_The_Provided_Stack_And_Pushes_The_Result_Onto_The_Stack()
{
    VMStack* stack = VMCreateStack(1024, 100);
    VMContext* context = VMCreateContext(1);

    int twoData = 2;
    int threeData = 3;
    VMPrimitive two;
    two.data = (void*)&twoData;
    two.argType = INT;
    VMPrimitive three;
    three.data = (void*)&threeData;
    three.argType = INT;

    // Push 2 and 3 onto the stack to begin with
    VMStackPush(stack, &two);
    VMStackPush(stack, &three);

    // Then create a method whose only instruction is to ADD whatever is on the stack
    VMMethod method;
    VMInstruction addInstruction;
    addInstruction.type = ADD;
    method.instructionCount = 1;
    method.instructions = &addInstruction;
    context->methodCount = 1;
    context->methods = &method;

    // Then execute that method
    VMExecuteMethod(context, stack, 0);

    // Then we can inspect what is actually there
    VMPrimitive* stackContents = VMStackPeek(stack);
    int* result = (int*)stackContents->data;

    assert_is_true(*result == 5, "Op code 'Add' did not place the correct result on the stack");

}

void Adding_Two_Numbers_Places_Result_On_Stack()
{
    // A context
    VMContext* context = VMCreateContext(1);
    VMStack* stack = VMCreateStack(1024, 100);

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

    VMExecuteMethod(context, stack, 0);

    int resultData;
    VMPrimitive result;
    result.argType = INT;
    result.data = (void*)&resultData;
    VMStackPop(stack, &result);

    assert_is_true(resultData == 5, "The result of 2 + 3 was not as expected");

    VMDestroyStack(stack);
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
    Allocating_A_Primitive_On_The_Stack_Copies_Data_Into_The_Stack();
    Popping_A_Primitive_Off_The_Stack_Copies_Data_Into_The_Output();

    OpCode_Push_Pushes_The_Argument_Onto_The_Provided_Stack();
    OpCode_Pop_Pops_The_Next_Item_Off_The_Provided_Stack();
    OpCode_Add_Adds_The_Two_Numbers_On_The_Provided_Stack_And_Pushes_The_Result_Onto_The_Stack();

    Adding_Two_Numbers_Places_Result_On_Stack();

    return 0;
}
