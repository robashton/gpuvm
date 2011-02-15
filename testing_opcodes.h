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

void OpCode_Add_Adds_The_Two_Ints_On_The_Provided_Stack_And_Pushes_The_Result_Onto_The_Stack()
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

    assert_is_true(*result == 5, "Op code 'Add' did not place the correct result on the stack (%d) not 5", *result);
}

void OpCode_Add_Adds_The_Two_Floats_On_The_Provided_Stack_And_Pushes_The_Result_Onto_The_Stack()
{
    VMStack* stack = VMCreateStack(1024, 100);
    VMContext* context = VMCreateContext(1);

    float twoData = 2.0f;
    float threeData = 3.0f;
    VMPrimitive two;
    two.data = (void*)&twoData;
    two.argType = FLOAT;
    VMPrimitive three;
    three.data = (void*)&threeData;
    three.argType = FLOAT;

    // Push 2.0f and 3.0f onto the stack to begin with
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
    float* result = (float*)stackContents->data;

    assert_is_true((int)(*result) == 5, "Op code 'Add' did not place the correct result on the stack (%d) not 5.0f", *result);
}

void test_opcodes()
{
    OpCode_Push_Pushes_The_Argument_Onto_The_Provided_Stack();
    OpCode_Pop_Pops_The_Next_Item_Off_The_Provided_Stack();
    OpCode_Add_Adds_The_Two_Ints_On_The_Provided_Stack_And_Pushes_The_Result_Onto_The_Stack();
    OpCode_Add_Adds_The_Two_Floats_On_The_Provided_Stack_And_Pushes_The_Result_Onto_The_Stack();
}

