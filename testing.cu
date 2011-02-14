#include <stdlib.h>
#include <stdio.h>

#include "testing.h"

void assert_is_true(int value, const char* message)
{
    if(value != 1)
    {
        printf("Test Failed: %s", message);
    }
}
