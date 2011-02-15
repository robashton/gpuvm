#ifndef VMSTACK_H
#define VMSTACK_H

#include "vmtypes.h"

typedef struct VMStack
{
    unsigned char* data;
    int currentItem;
    int maxitems;
    VMPrimitive* items;
} VMStack;


VMStack* VMCreateStack(int sizeInBytes, int maximumItems);
void VMDestroyStack(VMStack* stack);
void VMStackAlloc(VMStack* stack, VMPrimitiveType type);
void VMStackFree(VMStack* stack);

void VMStackPush(VMStack* stack, VMPrimitive* input);
void VMStackPop(VMStack* stack, VMPrimitive* output);
VMPrimitive* VMStackPeek(VMStack* stack);

#endif
