import testinfra

def test_vscodium_install(host):
    assert host.package("codium").is_installed

def test_vscodium_config_copy(host):
    assert not host.ansible(
        "copy",
        "src=/tmp/files/config/vscodium/ dest=$HOME")["changed"]

def test_vscodium_extensions(host):
    expected_extensions = (
          "alefragnani.Bookmarks",
          "ms-vscode.cpptools",
          "stkb.rewrap",
          "streetsidesoftware.code-spell-checker",
          "vscodevim.vim",
          "ms-vscode.cmake-tools",
          "twxs.cmake"
          )

    cmd = host.run("codium %s", "--list-extensions")
    installed_extensions = cmd.stdout.splitlines()

    for expected_extension in expected_extensions:
        assert expected_extension in installed_extensions
