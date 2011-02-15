#ifndef VMTYPES_H
#define VMTYPES_H


#ifndef TESTINGMODE
#define GLOBAL __global__ void
#define DEVICE __device__ void
#else
#define GLOBAL void
#define DEVICE void
#endif


typedef enum VMInstructionType { ADD, PUSH, POP } VMInstructionType;
typedef enum VMPrimitiveType { INT } VMPrimitiveType;

typedef struct VMPrimitive
{
    void* data;
    VMPrimitiveType argType;
} VMPrimitive;

typedef struct VMInstruction
{
    VMInstructionType type;
    VMPrimitive arg;
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


typedef struct VMExecutionContext
{
    void* stack;
} VMExecutionContext;


#endif
