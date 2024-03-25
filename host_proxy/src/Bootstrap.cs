using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace HostProxy
{
    public class HostProxy
    {
        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe int Bootstrap(IntPtr managed, int managedBytes,
                                           IntPtr unmanaged, int unmanagedBytes)
        {
            // TODO: Set up our host proxy. This function is responsible for mapping
            //       various function pointers to implementation so that managed
            //       can call native and native can call managed
            return 0;
        }
    }
}
