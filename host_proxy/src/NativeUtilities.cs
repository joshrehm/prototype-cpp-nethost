using System;
using System.Text;

namespace HostProxy
{
    // Utility functions for marshalling data between native host and managed code
    public class NativeUtilities
    {
        public static unsafe string MarshalNativeString(byte* bytePointer)
        {
            var p = bytePointer;
            while (*p != '\0')
                ++p;
            return Encoding.UTF8.GetString(bytePointer, (int)(p - bytePointer));
        }

        public static unsafe int MarshalNativeString(string str, byte* out_buffer, int out_size)
        {
            if (out_buffer == null)
                throw new ArgumentNullException("out_buffer");
            
            var utf8Bytes = Encoding.UTF8.GetBytes(str);
            var length = Math.Min(utf8Bytes.Length, out_size - 1);
            fixed (byte* utf8Pointer = utf8Bytes)
                Buffer.MemoryCopy(utf8Pointer, out_buffer, out_size, length);

            out_buffer[length] = 0;
            return length;
        }
    }
}
