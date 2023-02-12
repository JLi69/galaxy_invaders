#if defined(_MSC_VER) || defined(__MINGW32__)
#include <time.h>
#ifndef _TIMEVAL_DEFINED /* also in winsock[2].h */
#define _TIMEVAL_DEFINED
struct timeval 
{
	long tv_sec;
	long tv_usec;
};
#endif /* _TIMEVAL_DEFINED */
#else
#include <sys/time.h>
#endif



#if defined(_MSC_VER) || defined(__MINGW32__)
int gettimeofday(struct timeval* tp, void* tzp) 
{
	DWORD t;
	t = timeGetTime();
	tp->tv_sec = t / 1000;
	tp->tv_usec = t % 1000;
	/* 0 indicates that the call succeeded. */
	return 0;
}
#endif
