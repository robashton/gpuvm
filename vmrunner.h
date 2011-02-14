#ifndef VMRUNNER_H
#define VMRUNNER_H

typedef enum VMInstructionType { ADD, PUSH, POP } VMInstructionType;
typedef enum VMPrimitiveType { INT } VMPrimitiveType;

typedef struct VMInstructionArg
{
    void* data;
    VMPrimitiveType argType;
} VMInstructionArg;

typedef struct VMInstruction
{
    VMInstructionType type;

} VMInstruction;

typedef struct VMMethod
{
    VMInstruction* instructions;
    int instructionCount;

} VMMethod;

typedef struct VMContext
{
    VMMethod* methods;
    int methodCount;
} VMContext;


// This is the execution context for a method call chain, There is therefore one of these per 'actor'
typedef struct VMExecutionContext
{
    void* stack;
    int stackPointer;
    int instructionPointer;
} VMExecutionContext;

VMContext* VMCreateContext(int methodCount);
void VMDestroyContext(VMContext* context);


void ExecuteMethod(VMContext* context, VMExecutionContext* executionContext, int method);

#endif
