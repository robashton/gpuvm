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

void VMExecuteMethod(VMContext* context, int method)
{

}
