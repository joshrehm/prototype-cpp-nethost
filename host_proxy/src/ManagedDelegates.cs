using System;
using System.Runtime;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace HostProxy
{
    // A structure that will contain a list of C# delegate function pointers the native host
    // may use to call into managed code.
    [StructLayout(LayoutKind.Sequential)]
    internal unsafe struct ManagedDelegates
    {
        public delegate* unmanaged[Stdcall]<IntPtr, byte*, int, void> Module_Name;
        public delegate* unmanaged[Stdcall]<IntPtr, byte*, int, void> Module_Namespace;
        public delegate* unmanaged[Stdcall]<IntPtr, byte*, int, void> Module_AssemblyName;
        public delegate* unmanaged[Stdcall]<IntPtr, byte*, int, void> Module_AssemblyVersion;
    }
}