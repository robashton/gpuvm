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

    VMStackAlloc(stack, 4);
    VMStackAlloc(stack, 8);

    assert_is_true(stack->currentItem == 1, "Current stack item after allocation is not correct");
    assert_is_true(stack->items[1].data == (void*)(stack->data + 4), "Top item does not point at correct location in stack");
    assert_is_true(stack->items[0].data == (void*)stack->data, "Old item does not point at first location in the stack");

    VMDestroyStack(stack);
}

void Freeing_An_Item_Off_The_Stack_Decreases_Stack_Pointer()
{
    VMStack* stack = VMCreateStack(1024, 100);

    VMStackAlloc(stack, 4);
    VMStackAlloc(stack, 8);

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

void test_stack()
{
    Creating_A_Stack_Initializes_StackData();
    Allocating_An_Item_On_The_Stack_Increases_Stack_Pointer();
    Freeing_An_Item_Off_The_Stack_Decreases_Stack_Pointer();
    Allocating_A_Primitive_On_The_Stack_Copies_Data_Into_The_Stack();
    Popping_A_Primitive_Off_The_Stack_Copies_Data_Into_The_Output();
}
