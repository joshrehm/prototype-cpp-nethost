using System;
using System.Runtime;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace HostProxy
{
    internal class ManagedProxy
    {
        // Populate an instances of ManagedDelegates.
        internal static unsafe ManagedDelegates GetManagedDelegates()
        {
            var delegates = new ManagedDelegates();
            
            delegates.Module_Name = &Module_Name;
            delegates.Module_Namespace = &Module_Namespace;
            delegates.Module_AssemblyName = &Module_AssemblyName;
            delegates.Module_AssemblyVersion = &Module_AssemblyVersion;

            return delegates;
        }
        
        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe void Module_Name(IntPtr module, byte* out_buffer, int out_size)
        {
            // TODO: Implement me. Delegate the call to a managed IModule instance
            //       identified by `module`.
        }

        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe void Module_Namespace(IntPtr module, byte* out_buffer, int out_size)
        {
            // TODO: Implement me. Delegate the call to a managed IModule instance
            //       identified by `module`.
        }

        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe void Module_AssemblyName(IntPtr module, byte* out_buffer, int out_size)
        {
            // TODO: Implement me. Delegate the call to a managed IModule instance
            //       identified by `module`.
        }

        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe void Module_AssemblyVersion(IntPtr module, byte* out_buffer, int out_size)
        {
            // TODO: Implement me. Delegate the call to a managed IModule instance
            //       identified by `module`.
        }
    }

}