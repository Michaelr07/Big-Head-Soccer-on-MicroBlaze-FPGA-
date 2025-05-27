// syscalls.c
#include <sys/time.h>
#include <reent.h>

/*
 * Minimal stub for the reentrant gettimeofday.
 * Returns always zeroed time.  Link this file in your build.
 */
int _gettimeofday_r(struct _reent *r, struct timeval *tp, void *tz)
{
    (void)r;
    if (tp) {
        tp->tv_sec  = 0;
        tp->tv_usec = 0;
    }
    return 0;
}

/*
 * Some toolchains also require the non reentrant symbol:
 */
int gettimeofday(struct timeval *tp, void *tz)
{
    return _gettimeofday_r(NULL, tp, tz);
}
