import testinfra

def test_git_install(host):
    assert host.package("git").is_installed

def test_git_support_install(host):
    assert host.package("gitk").is_installed
    assert host.package("git-gui").is_installed

def test_git_config_exists(host):
    import os
    assert host.file(os.path.join(host.user().home, ".gitconfig")).exists

def test_git_config_expected_content(host):
    import configparser
    import os

    config = configparser.ConfigParser()
    config.read(os.path.join(host.user().home, ".gitconfig"))
    assert config.has_option("user", "name")
    assert config["user"]["name"] == os.environ["GIT_USER_NAME"]
    assert config.has_option("user", "email")
    assert config["user"]["email"] == os.environ["GIT_USER_EMAIL"]
