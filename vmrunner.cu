#include "vmrunner.h"

VMContext* VMCreateContext(int methodCount)
{
    VMContext* context = (VMContext*)malloc(sizeof(VMContext));
    context->methodCount = methodCount;
    context->methods = (VMMethod*)malloc(sizeof(VMMethod) * methodCount);
    return context;
}

void VMDestroyContext(VMContext* context)
{
    free(context->methods);
    free(context);
}

void VMExecuteMethod(VMContext* context, VMStack* stack, int method)
{
    int instructionPointer = 0;
    VMMethod* methodPtr = &context->methods[method];
    do
    {
        VMInstruction* instr = &methodPtr->instructions[instructionPointer];

        switch(instr->type)
        {
            case ADD:

            break;
            case PUSH:
              //  instr->arg.data

            break;
            case POP:

            break;
            default:

            break;
        }


    } while(instructionPointer < methodPtr->instructionCount);
}
