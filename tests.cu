#include <stdio.h>
#include <stdlib.h>

#ifdef TESTINGMODE

#include "gpuvm.h"
#include "testing.h"

#include "testing_vmstack.h"
#include "testing_vmheap.h"
#include "testing_vmengine.h"
#include "testing_opcodes.h"

int main()
{
    printf("Running tests\n\n");

    test_engine();
    test_heap();
    test_opcodes();
    test_stack();

    printf("Ran all tests\n\n");

    return 0;
}

#endif
