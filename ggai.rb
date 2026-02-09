class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/c4/f7/893e117029714e024884ec6f2362bfdc40c3460a641438129fab7a867fde/ggai-0.5.0.tar.gz"
  sha256 "a4a2ea6c3dc08e6193f382c16b8df3a8f994ccfcc539c3a9f59164c14d3dc3ef"
  license "MIT"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
    system libexec/"bin/python", "-m", "pip", "install", "openai", "pyobjc", "pillow"
  end

  test do
    system "#{bin}/ggai", "--help"
  end
end
