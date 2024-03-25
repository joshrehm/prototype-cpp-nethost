#pragma once

#include<array>
#include<coreclr_delegates.h>
#include<nethost.h>
#include<hostfxr.h>
#include<Windows.h>

class dotnet_host_loader
{
public:
    dotnet_host_loader() :
        hlib_(nullptr)
    {
    }

    ~dotnet_host_loader()
    {
        if (hlib_)
            FreeLibrary(hlib_);
        hlib_ = nullptr;
    }

    dotnet_host_loader(dotnet_host_loader const&) = delete;
    dotnet_host_loader(dotnet_host_loader&&) noexcept = default;

    dotnet_host_loader& operator=(dotnet_host_loader const&) = delete;
    dotnet_host_loader& operator=(dotnet_host_loader&&) noexcept = default;

public:
    template<typename TBootstrapSignaturePtr>
    auto get_bootstrap_delegate(TBootstrapSignaturePtr* delegate_ptr,
        wchar_t const* delegate_name,
        wchar_t const* assembly_name,
        wchar_t const* assembly_path, 
        wchar_t const* runtime_config_path)
    {
        if (auto rc = load_hostfxr())
            return rc;

        return get_bootstrap_delegate(reinterpret_cast<void**>(delegate_ptr), 
            delegate_name, assembly_name, assembly_path, runtime_config_path);
    }

private:
    auto load_hostfxr()
    {
        wchar_t runtime_path[MAX_PATH];
        auto runtime_path_size = std::size(runtime_path);

        if (auto rc = get_hostfxr_path(runtime_path, &runtime_path_size, nullptr))
            return rc;

        hlib_ = LoadLibraryW(runtime_path);
        if (!hlib_)
            return static_cast<int>(HRESULT_FROM_WIN32(GetLastError()));

        auto const proc_load = []<typename TSignature>(HMODULE lib, char const* name, TSignature* sig) {
            *sig = reinterpret_cast<decltype(sig)>(GetProcAddress(lib, name));
            if (!*sig) return static_cast<int>(HRESULT_FROM_WIN32(GetLastError()));
            return 0;
        };

        hostfxr_initialize_for_runtime_config_ = reinterpret_cast<hostfxr_initialize_for_runtime_config_fn>(
            GetProcAddress(hlib_, "hostfxr_initialize_for_runtime_config"));
        if (!hostfxr_initialize_for_runtime_config_)
            return static_cast<int>(HRESULT_FROM_WIN32(GetLastError()));

        hostfxr_get_runtime_delegate_ = reinterpret_cast<hostfxr_get_runtime_delegate_fn>(
            GetProcAddress(hlib_, "hostfxr_get_runtime_delegate"));
        if (!hostfxr_get_runtime_delegate_)
            return static_cast<int>(HRESULT_FROM_WIN32(GetLastError()));

        hostfxr_close_ = reinterpret_cast<hostfxr_close_fn>(
            GetProcAddress(hlib_, "hostfxr_close"));
        if (!hostfxr_close_)
            return static_cast<int>(HRESULT_FROM_WIN32(GetLastError()));

        return 0;
    }

    auto get_bootstrap_delegate(void** delegate_ptr,
        wchar_t const* delegate_name,
        wchar_t const* assembly_name,
        wchar_t const* assembly_path, 
        wchar_t const* runtime_config_path)
    {
        hostfxr_handle hfxr;
        if (auto rc = hostfxr_initialize_for_runtime_config_(runtime_config_path, nullptr, &hfxr))
            return rc;

        load_assembly_and_get_function_pointer_fn load_assembly_and_get_function_pointer;
        if (auto rc = hostfxr_get_runtime_delegate_(hfxr, hdt_load_assembly_and_get_function_pointer, 
            reinterpret_cast<void**>(&load_assembly_and_get_function_pointer)))
        {
            hostfxr_close_(hfxr);
            return rc;
        }

        hostfxr_close_(hfxr);

        if (auto rc = load_assembly_and_get_function_pointer(assembly_path, assembly_name, delegate_name, 
            UNMANAGEDCALLERSONLY_METHOD, nullptr, delegate_ptr))
        {
            return rc;
        }

        return 0;
    }

private:
    HMODULE hlib_;
    hostfxr_initialize_for_runtime_config_fn hostfxr_initialize_for_runtime_config_;
    hostfxr_get_runtime_delegate_fn hostfxr_get_runtime_delegate_;
    hostfxr_close_fn hostfxr_close_;
};

