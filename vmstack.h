#ifndef VMSTACK_H
#define VMSTACK_H

#include "vmtypes.h"

typedef struct VMStackItem
{
    VMPrimitiveType type;
    int index;
} VMStackItem;

typedef struct VMStack
{
    unsigned char* data;
    int currentItem;
    int maxitems;
    VMStackItem* items;
} VMStack;


VMStack* VMCreateStack(int sizeInBytes, int maximumItems);
void VMDestroyStack(VMStack* stack);
void VMStackAlloc(VMStack* stack, int size);
void VMStackFree(VMStack* stack);

void VMStackPush(VMStack* stack, void* data, VMPrimitiveType type);
void VMStackPop(VMStack* stack, void* dest, VMPrimitiveType type);
VMStackItem* VMStackPeek(VMStack* stack);

#endif
