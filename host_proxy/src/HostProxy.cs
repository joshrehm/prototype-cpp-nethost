using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace HostProxy
{
    public class HostProxy
    {
        internal static NativeApi NativeApi { get; private set; }

        // Managed bootstrap function. Called by the native host application when the assembly
        // is loaded.
        //
        // The native host passes in two memory spaces:
        //
        //   unmanaged, unmanagedBytes: A memory space containing a list of native function
        //                              pointers. These pointers allow calling into the native
        //                              host from managed code.
        //
        //                              Available function pointers are defined by `NativeDelegates`
        //                              and must match the order of the `native_host_proxy` struct
        //                              members in the native host project. 
        //
        //                              The `unmanagedBytes` variable contains the size, in bytes,
        //                              of the memory space. This may be used to do basic versioning
        //                              of the available native API.
        //
        //  managed, managedBytes:      A zero-initialized memory space in which the HostProxy must
        //                              store function pointers the native host may use to call into
        //                              the managed API.
        //
        //                              Available function pointers are defined by ManagedDelegates
        //                              and must match the order of the `managed_host_proxy` struct
        //                              members in the native host project.
        //
        //                              The `managedBytes` variable contains the size, in bytes,
        //                              of the memory space. This may be used to do basic versioning
        //                              of the available managed API. The native host may install 
        //                              default implementations for use by the native process for any
        //                              null function pointer after Bootstrap returns.
        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe int Bootstrap(IntPtr unmanaged, int unmanagedBytes,
                                           IntPtr managed, int managedBytes)
        {
            // Construct our managed function pointer delegates and populate the native 
            // memory space.
            //
            // TODO: Verify managedBytes is the size we expect.,
            Marshal.StructureToPtr(ManagedProxy.GetManagedDelegates(), 
                managed, false);

            // Construct our native function pointer delegates from the passed native
            // memory space.
            //
            // TODO: Verify unmanagedBytes is the size we expect.
            NativeApi = new NativeApi(
                    Marshal.PtrToStructure<NativeDelegates>(unmanaged));

            NativeApi.DebugLog("Loaded proxy interface");
            return 0;
        }
    }
}
