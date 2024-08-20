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
        public delegate* unmanaged[Stdcall]<byte*, IntPtr> Module_Load;
        public delegate* unmanaged[Stdcall]<IntPtr, void> Module_Release;
        public delegate* unmanaged[Stdcall]<IntPtr, byte*, int, int> Module_Name;
        public delegate* unmanaged[Stdcall]<IntPtr, byte*, int, int> Module_Namespace;
        public delegate* unmanaged[Stdcall]<IntPtr, byte*, int, int> Module_Version;
        public delegate* unmanaged[Stdcall]<IntPtr, byte*, int, int> Module_AssemblyName;
    }
}