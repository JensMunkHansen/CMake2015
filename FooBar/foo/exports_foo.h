// Contents of DLLDefines.h
#ifndef _DEF_EXPORTS_H
#define _DEF_EXPORTS_H

#if defined (_WIN32) 
  #if defined(_FOO_DYNAMIC_LINKING)
    #if defined(_FOO_EXPORTS)
      #define  FOO_DLL_EXPORT __declspec(dllexport)
    #else
      #define  FOO_DLL_EXPORT __declspec(dllimport)
    #endif /* SlopeBeamformer_EXPORTS */
  #else
    #define    FOO_DLL_EXPORT
  #endif
#else /* defined (_WIN32) */
  #define FOO_DLL_EXPORT
#endif

#endif
