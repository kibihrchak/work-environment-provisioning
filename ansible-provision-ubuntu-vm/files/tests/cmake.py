import testinfra

def test_cmake_install(host):
    assert host.package("cmake").is_installed

def test_clang_tools_install(host):
    assert host.package("clang-format").is_installed
    assert host.package("clang-tidy").is_installed
