import testinfra

def test_xfce4_prerequisites_installed(host):
    prerequisite_packages = (
        "xorg",
        "xinit",
        "dbus-x11",
        "upower"
    )

    for prerequisite_package in prerequisite_packages:
        assert host.package(prerequisite_package).is_installed

def test_display_manager_installed(host):
    dm_packages = (
        "policykit-1",
        "lightdm",
        "lightdm-gtk-greeter"
    )

    for dm_package in dm_packages:
        assert host.package(dm_package).is_installed

def test_xfce4_installed(host):
    xfce4_packages = (
        "xfce4",
        "xfce4-taskmanager",
        "xfce4-systemload-plugin",
        "xfce4-whiskermenu-plugin"
    )

    for xfce4_package in xfce4_packages:
        assert host.package(xfce4_package).is_installed

def test_xfce4_themes_installed(host):
    xfce4_theme_packages = (
        "xubuntu-icon-theme",
        "greybird-gtk-theme"
    )

    for xfce4_theme_package in xfce4_theme_packages:
        assert host.package(xfce4_theme_package).is_installed

def test_unused_not_installed(host):
    assert not host.package("humanity-icon-theme").is_installed

def test_xfce4_config_copy(host):
    assert not host.ansible(
        "copy",
        "src=/tmp/files/config/xfce4/ dest=$HOME")["changed"]
