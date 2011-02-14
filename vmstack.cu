#include "vmstack.h"


VMStack* VMCreateStack(int sizeInBytes, int maximumItems)
{
    VMStack* stack = (VMStack*)malloc(sizeof(VMStack));
    stack->currentItem = -1;
    stack->maxitems = maximumItems;
    stack->data = (unsigned char*)malloc(sizeInBytes);
    stack->items = (int*)malloc(maximumItems * sizeof(int*));

    return stack;
}

void VMStackAlloc(VMStack* stack, int size)
{
    stack->currentItem++;

    if(stack->currentItem == 0)
    {
        stack->items[0] = 0;
    }
    else
    {
        stack->items[stack->currentItem] = stack->items[stack->currentItem-1] + size;
    }
}

void VMStackFree(VMStack* stack)
{
    stack->currentItem--;
}

void VMDestroyStack(VMStack* stack)
{
    free(stack->items);
    free(stack->data);
    free(stack);
}
