#include "vmstack.h"


VMStack* VMCreateStack(int sizeInBytes, int maximumItems)
{
    VMStack* stack = (VMStack*)malloc(sizeof(VMStack));
    stack->currentItem = -1;
    stack->maxitems = maximumItems;
    stack->data = (unsigned char*)malloc(sizeInBytes);
    stack->items = (VMStackItem*)malloc(maximumItems * sizeof(VMStackItem));

    return stack;
}

void VMStackAlloc(VMStack* stack, int size)
{
    stack->currentItem++;

    if(stack->currentItem == 0)
    {
        stack->items[0].index = 0;
    }
    else
    {
        stack->items[stack->currentItem].index = stack->items[stack->currentItem-1].index + size;
    }
}

void VMStackFree(VMStack* stack)
{
    stack->currentItem--;
}

void VMStackPush(VMStack* stack, void* src, VMPrimitiveType type)
{
    int size = sizeof(int);
    VMStackAlloc(stack, size);

    VMStackItem* item = &stack->items[stack->currentItem];
    item->type = type;

    void* stackPtr = (void*)(stack->data + item->index);
    memcpy(stackPtr, src, size);
}

void VMStackPop(VMStack* stack, void* dest, VMPrimitiveType type)
{
    int size = sizeof(int);
    VMStackItem* item = &stack->items[stack->currentItem];

    void* stackPtr = (void*)(stack->data + item->index);

    memcpy(dest, stackPtr, size);
    VMStackFree(stack);
}

VMStackItem* VMStackPeek(VMStack* stack)
{
    return &stack->items[stack->currentItem];
}


void VMDestroyStack(VMStack* stack)
{
    free(stack->items);
    free(stack->data);
    free(stack);
}
