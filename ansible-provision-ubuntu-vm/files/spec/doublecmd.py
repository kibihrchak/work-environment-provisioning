import testinfra

def test_doublecmd_install(host):
    assert host.package("doublecmd-gtk").is_installed

def test_doublecmd_config_copy(host):
    assert not host.ansible(
        "copy",
        "src=/tmp/files/config/doublecmd/ dest=$HOME")["changed"]
