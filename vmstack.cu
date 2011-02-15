#include "vmstack.h"


VMStack* VMCreateStack(int sizeInBytes, int maximumItems)
{
    VMStack* stack = (VMStack*)malloc(sizeof(VMStack));
    stack->currentItem = -1;
    stack->maxitems = maximumItems;
    stack->data = (unsigned char*)malloc(sizeInBytes);
    stack->items = (VMPrimitive*)malloc(maximumItems * sizeof(VMPrimitive));

    return stack;
}

void VMStackAlloc(VMStack* stack, VMPrimitiveType type)
{
    int size = sizeof(int);
    stack->currentItem++;

    if(stack->currentItem == 0)
    {
        stack->items[0].data = stack->data;
    }
    else
    {
        stack->items[stack->currentItem].data = (void*)(((unsigned char*)stack->items[stack->currentItem-1].data) + size);
    }
}

void VMStackFree(VMStack* stack)
{
    stack->currentItem--;
}

void VMStackPush(VMStack* stack, VMPrimitive* input)
{
    int size = sizeof(int);
    VMStackAlloc(stack, input->argType);

    VMPrimitive* item = &stack->items[stack->currentItem];
    item->argType = input->argType;

    memcpy(item->data, input->data, size);
}

void VMStackPop(VMStack* stack, VMPrimitive* output)
{
    int size = sizeof(int);
    VMPrimitive* item = &stack->items[stack->currentItem];

    memcpy(output->data, item->data, size);
    VMStackFree(stack);
}

VMPrimitive* VMStackPeek(VMStack* stack)
{
    return &stack->items[stack->currentItem];
}

void VMDestroyStack(VMStack* stack)
{
    free(stack->items);
    free(stack->data);
    free(stack);
}
