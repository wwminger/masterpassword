#ifndef _LIBSPECTRE_H
#define _LIBSPECTRE_H

#define DART_API extern "C" __attribute__((visibility("default"))) __attribute__((used))
// #include <stdint.h>
// #include <string.h>
// #include "spectre-algorithm.h"
// #include "spectre-util.h"
// #include "spectre-types.h"
char* generate(char* username, char* password, char* webname);
#endif
