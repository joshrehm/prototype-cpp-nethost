using System;
using System.IO;
using System.Reflection;
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

            delegates.Module_Load = &Module_Load;
            delegates.Module_Name = &Module_Name;
            delegates.Module_Namespace = &Module_Namespace;
            delegates.Module_Version = &Module_Version;
            delegates.Module_AssemblyName = &Module_AssemblyName;

            return delegates;
        }

        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe IntPtr Module_Load(byte* path)
        {
            // TODO: Set last error API?
            if (path == null)
                return IntPtr.Zero;

            try
            {
                var modulePath = NativeUtilities.MarshalNativeString(path);
                var module = Module.Load(modulePath);
                var handle = GCHandle.Alloc(module);
                return GCHandle.ToIntPtr(handle);
            }
            catch (Exception)
            {
                // TODO: Set last error API
                return IntPtr.Zero;
            }
        }

        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe void Module_Release(IntPtr moduleHandle)
        {
            try
            {

                var handle = GCHandle.FromIntPtr(moduleHandle);
                handle.Free();
            }
            catch (Exception)
            {
                // TODO: Set last error API
            }
        }

        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe int Module_Name(IntPtr moduleHandle, byte* out_buffer, int out_size)
        {
            try
            {

                var handle = GCHandle.FromIntPtr(moduleHandle);
                var module = (Module)handle.Target;
                return NativeUtilities.MarshalNativeString(module.ModuleInfo.Name, out_buffer, out_size);
            }
            catch (Exception)
            {
                // TODO: Set last error API
                return 0;
            }
        }

        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe int Module_Namespace(IntPtr moduleHandle, byte* out_buffer, int out_size)
        {
            try
            {

                var handle = GCHandle.FromIntPtr(moduleHandle);
                var module = (Module)handle.Target;
                return NativeUtilities.MarshalNativeString(module.ModuleInfo.Namespace, out_buffer, out_size);
            }
            catch (Exception)
            {
                // TODO: Set last error API
                return 0;
            }
        }

        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe int Module_Version(IntPtr moduleHandle, byte* out_buffer, int out_size)
        {
            try
            {

                var handle = GCHandle.FromIntPtr(moduleHandle);
                var module = (Module)handle.Target;
                return NativeUtilities.MarshalNativeString(module.ModuleInfo.Version, out_buffer, out_size);
            }
            catch (Exception)
            {
                // TODO: Set last error API
                return 0;
            }
        }

        [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvStdcall) })]
        public static unsafe int Module_AssemblyName(IntPtr moduleHandle, byte* out_buffer, int out_size)
        {
            try
            {

                var handle = GCHandle.FromIntPtr(moduleHandle);
                var module = (Module)handle.Target;
                return NativeUtilities.MarshalNativeString(module.ModuleInfo.AssemblyName, out_buffer, out_size);
            }
            catch (Exception)
            {
                // TODO: Set last error API
                return 0;
            }
        }
    }

}