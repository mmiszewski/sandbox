/* 
 * <unistd.h>
 *
 * na win32 widocznie nie ma strncasecmp().
 *
 * $Id: unistd.h,v 1.2 2002-08-07 14:37:06 wojtekka Exp $
 */

#ifndef COMPAT_UNISTD_H
#define COMPAT_UNISTD_H

#define strncasecmp strnicmp

#endif /* COMPAT_UNISTD_H */
