#ifndef VMSTACK_H
#define VMSTACK_H

typedef struct VMStack
{
    unsigned char* data;
    int currentItem;
    int maxitems;
    int* items;
} VMStack;


VMStack* VMCreateStack(int sizeInBytes, int maximumItems);
void VMDestroyStack(VMStack* stack);
void VMStackAlloc(VMStack* stack, int size);
void VMStackFree(VMStack* stack);

#endif
