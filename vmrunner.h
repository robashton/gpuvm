#ifndef VMRUNNER_H
#define VMRUNNER_H

#include "vmtypes.h"
#include "vmheap.h"

VMContext* VMCreateContext(int methodCount);
void VMDestroyContext(VMContext* context);
void VMExecuteMethod(VMContext* context, int method);

GLOBAL DoSomething(int x, int y);


#endif
