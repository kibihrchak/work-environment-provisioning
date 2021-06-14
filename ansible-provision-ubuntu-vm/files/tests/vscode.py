import testinfra

def test_vscodium_install(host):
    assert host.package("code").is_installed

def test_vscodium_config_copy(host):
    assert not host.ansible(
        "copy",
        "src=/tmp/files/config/vscode/ dest=$HOME")["changed"]

def test_vscodium_extensions(host):
    expected_extensions = (
          "alefragnani.Bookmarks",
          "stkb.rewrap",
          "streetsidesoftware.code-spell-checker",
          "asvetliakov.vscode-neovim"
          )

    cmd = host.run("code %s", "--list-extensions")
    installed_extensions = cmd.stdout.splitlines()

    for expected_extension in expected_extensions:
        assert expected_extension in installed_extensions
