import testinfra

def test_pandoc_installed(host):
    assert host.package("pandoc").is_installed

def test_pandoc_command_available(host):
    assert host.exists("pandoc")

def test_pandoc_matplotlib_installed(host):
    assert "matplotlib" in host.pip_package.get_packages("pip3")

def test_pandoc_pandoc_plot_0_7_1_0_installed(host):
    assert host.exists("pandoc-plot")
    assert host.find_command("pandoc-plot") == "/usr/local/bin/pandoc-plot"
    assert host.run("pandoc-plot --version | grep {0}".format("0.7.1.0")).succeeded

def test_pandoc_diagram_generator_installed(host):
    assert host.file("/home/vagrant/.local/share/pandoc/filters/diagram-generator.lua").sha256sum == "316f3d9b8199537e10e0564793922f7c023b70fe23f0238b4755906155cecd45"

def test_pandoc_pantable_installed(host):
    assert "pantable" in host.pip_package.get_packages("pip3")

def test_plantuml_prerequisite_jre_installed(host):
    assert host.package("openjdk-14-jre-headless").is_installed

def test_plantuml_prerequisite_graphviz_installed(host):
    assert host.package("graphviz").is_installed

def test_plantuml_installed(host):
    assert host.file("/home/vagrant/Java/plantuml.1.2020.19.jar").sha256sum == "112b9c44ea069a9b24f237dfb6cb7a6cfb9cd918e507e9bee2ebb9c3797f6051"

def test_plantuml_envvar_set(host):
    env = host.environment()
    assert "PLANTUML" in env
    assert env["PLANTUML"] == "/home/vagrant/Java/plantuml.1.2020.19.jar"

def test_pandoc_pdf_export_latex_installed(host):
    expected_packages = (
          "texlive-latex-base",
          "texlive-latex-extra",
          "texlive-latex-recommended"
          )

    for expected_package in expected_packages:
        assert host.package(expected_package).is_installed

def test_pandoc_pdf_export_lmodern_installed(host):
    assert host.package("lmodern").is_installed

def test_pandoc_pdf_export_wkhtmltopdf(host):
    assert host.package("wkhtmltopdf").is_installed

def test_readthedocs_packages_installed(host):
    expected_packages = (
          "Sphinx",
          "recommonmark"
          )

    installed_packages = host.pip_package.get_packages("pip3")

    for expected_package in expected_packages:
        assert expected_package in installed_packages

def test_ruby_tools_packages_installed(host):
    expected_packages = (
          "ruby",
          "ruby-dev"
          )

    for expected_package in expected_packages:
        assert host.package(expected_package).is_installed

def test_ruby_tools_gems_installed(host):
    expected_gems = (
          "asciidoctor",
          "bundler",
          "jekyll"
          )

    for expected_gem in expected_gems:
        assert host.run("gem list {0} | grep {0}".format(expected_gem)).succeeded

def test_code_documentation_doxygen_installed(host):
    assert host.package("doxygen").is_installed

def test_code_documentation_breathe_installed(host):
    assert "breathe" in host.pip_package.get_packages("pip3")
