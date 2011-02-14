#ifndef VMTYPES_H
#define VMTYPES_H


#ifdef GPU
#define GLOBAL __global__ void
#define DEVICE __device__ void
#else
#define GLOBAL void
#define DEVICE void
#endif


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
    VMInstructionArg arg;
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
