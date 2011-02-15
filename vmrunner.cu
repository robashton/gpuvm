#include "vmrunner.h"
#include <stdio.h>

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
            {
                // Gasp, yes indeed I am taking advantage of the fact
                // That nothing will be writing into this stack
                // I actually *want* this, but need to formalise it
               VMStackItem* argOne = VMStackPeek(stack);
               VMStackFree(stack);
               VMStackItem* argTwo = VMStackPeek(stack);
               VMStackFree(stack);

                // Clearly I won't actually do it like this, it's just to prove a point
                switch(argOne->type)
                {
                    case INT:
                    {
                        int* intArgOne = (int*)(&stack->data[argOne->index]);
                        switch(argTwo->type)
                        {
                            case INT:
                            {
                                int* intArgTwo = (int*)(&stack->data[argTwo->index]);

                                int result = *intArgOne + *intArgTwo;
                                VMStackPush(stack, (void*)&result, INT);
                             break;
                            }
                        }
                        break;
                    }
                }
            break;
            }
            case PUSH:
            {
                printf("Push\n");
                VMStackPush(stack, instr->arg.data, INT);
                break;
            }
            case POP:
            {
                VMStackFree(stack);
                break;
            }
            default:
            {

            }
            break;
        }
        instructionPointer++;

    } while(instructionPointer < methodPtr->instructionCount);
}
