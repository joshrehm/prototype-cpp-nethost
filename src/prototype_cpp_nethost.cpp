#include"prototype_cpp_nethost/prototype_cpp_nethost.h"
#include<array>
#include<iostream>

#include<Windows.h>
#include<coreclr_delegates.h>
#include<nethost.h>
#include<hostfxr.h>

#define MAKE_WIDE2(s)  L ## s
#define MAKE_WIDE(s)   MAKE_WIDE2(s)

int main()
{
    // Verify we can call into hostfxr We'll refactor this to a full implementation later.
    auto buffer = std::array<wchar_t, MAX_PATH>{};
    auto buffer_size = std::size(buffer);

    auto rc = get_hostfxr_path(buffer.data(), &buffer_size, nullptr);
    if (rc)
    {
        std::cerr << "Failed to locate .NET Host Path" << std::endl;
        return 1;
    }

    std::wcout << L"Located .NET Host version " MAKE_WIDE(DOTNET_HOST_VERSION) " at '" << buffer.data() << L"'" << std::endl;
    return 0;
}
