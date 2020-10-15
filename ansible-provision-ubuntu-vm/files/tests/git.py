import testinfra

def test_git_install(host):
    assert host.package("git").is_installed

def test_git_support_install(host):
    assert host.package("gitk").is_installed
    assert host.package("git-gui").is_installed

def test_git_config_set_up(host):
    import os
    #   [TODO] Introduce content check
    assert host.file(os.path.join(host.user().home, ".gitconfig")).exists
