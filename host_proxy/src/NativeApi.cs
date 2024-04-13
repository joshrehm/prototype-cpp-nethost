namespace HostProxy
{
    // Convenience functions that wrap NativeDelegates. These functions expose a C#
    // style API and handle any required marshalling into the native delegates.
    public class NativeApi
    {
        private NativeDelegates delegates_;

        // Creates an instance of `NativeApi`. Callers should instead use the
        // `HostProxy.NativeApi` property.
        internal NativeApi(NativeDelegates delegates)
        {
            delegates_ = delegates;
        }

        // Outputs a debug log string to the native host's debug stream.
        public unsafe void DebugLog(string message)
        {
            var bytes = System.Text.Encoding.UTF8.GetBytes(message);
            fixed (byte* p = bytes)
            {
                delegates_.DebugLog(p, message.Length);
            }
        }
    }
}