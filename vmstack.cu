#include "vmstack.h"


VMStack* VMCreateStack(int sizeInBytes, int maximumItems)
{
    VMStack* stack = (VMStack*)malloc(sizeof(VMStack));
    stack->currentItem = -1;
    stack->maxitems = maximumItems;
    stack->data = (unsigned char*)malloc(sizeInBytes);
    stack->items = (VMPrimitive*)malloc(maximumItems * sizeof(VMPrimitive));
    stack->nextFree = stack->data;
    return stack;
}

void VMStackAlloc(VMStack* stack, int size)
{
    stack->currentItem++;
    stack->items[stack->currentItem].data = (void*)stack->nextFree;
    stack->nextFree += size;
}

void VMStackFree(VMStack* stack)
{
    stack->nextFree = (unsigned char*)stack->items[stack->currentItem].data;
    stack->currentItem--;
}

void VMStackPush(VMStack* stack, VMPrimitive* input)
{
    int size = VMSize(input);
    VMStackAlloc(stack, size);

    VMPrimitive* item = &stack->items[stack->currentItem];
    item->argType = input->argType;

    memcpy(item->data, input->data, size);
}

void VMStackPop(VMStack* stack, VMPrimitive* output)
{
    int size = VMSize(output);
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
