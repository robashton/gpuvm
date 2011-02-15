void A_New_Context_Has_Prescribed_Number_Of_Methods()
{
    VMContext* context = VMCreateContext(1);
    assert_is_true(context->methodCount == 1, "Context had incorrect number of methods");
    VMDestroyContext(context);
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

void  test_engine()
{
    A_New_Context_Has_Prescribed_Number_Of_Methods();
    Adding_Two_Numbers_Places_Result_On_Stack();
}
