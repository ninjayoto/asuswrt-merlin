#ifndef DROPBEAR_OPTIONS_H
#define DROPBEAR_OPTIONS_H

/* 
            > > > Don't edit this file any more! < < <
            
Local compile-time configuration should be defined in localoptions.h
in the build directory.
See default_options.h.in for a description of the available options.
*/

/* Some configuration options or checks depend on system config */
#include "config.h"

#ifdef LOCALOPTIONS_H_EXISTS
#include "localoptions.h"
#endif

/* default_options.h is processed to add #ifndef guards */
#include "default_options_guard.h"

/* Some other defines that mostly should be left alone are defined
 * in sysoptions.h */
#include "sysoptions.h"

/* Overrides for sysoptions.h */
#ifdef DROPBEAR_SERVER_TCP_FAST_OPEN
#undef DROPBEAR_SERVER_TCP_FAST_OPEN
#endif

#endif /* DROPBEAR_OPTIONS_H */
