using System;
using System.Runtime;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace HostProxy
{
    // Represents a memory space of native function pointers that are passed in from
    // the host process via the `HostProxy.Bootstrap` method.
    //
    // For convenience, callers should use the NativeApi methods instead which handle
    // any necessary parameter and return value marshalling.
    [StructLayout(LayoutKind.Sequential)]
    internal unsafe struct NativeDelegates
    {
        public delegate* unmanaged[Stdcall]<byte*, int, void> DebugLog;
    }
}