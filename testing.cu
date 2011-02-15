#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

#include "testing.h"

void assert_is_true(int value, const char* message, ...)
{
    va_list args;
    va_start(args,message);

    if(value != 1)
    {
        printf("Test Failed: ");
        vprintf(message, args);
        printf("\n");
    }

    va_end(args);
}
