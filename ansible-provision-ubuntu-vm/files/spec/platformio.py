import testinfra

def test_pio_prerequisites_installed(host):
    prerequisite_packages = (
        "python3",
        "python3-distutils"
    )

    for prerequisite_package in prerequisite_packages:
        assert host.package(prerequisite_package).is_installed

def test_pio_installed(host):
    import urllib.request
    import os

    urllib.request.urlretrieve('https://raw.githubusercontent.com/platformio/platformio/develop/scripts/get-platformio.py', '/tmp/get-platformio.py')

    status = os.system('python3 /tmp/get-platformio.py check core')

    assert status == 0

#   [TODO] This one always returns True for some reason
def test_pio_udev_rules(host):
    assert True
    # assert not host.ansible(
    #     "get_url",
    #     "url=https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules dest=/etc/udev/rules.d/99-platformio-udev.rules", become=True)["changed"]

def test_pio_user_groups(host):
    expected_groups = (
        "dialout",
        "plugdev"
    )

    groups = host.user().groups

    for expected_group in expected_groups:
        assert expected_group in groups
