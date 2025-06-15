class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/d2/f2/f0e9901f3381400781f15f49730d6ebd4b8b564dbce94fe7a9e0fbfa3cbd/ggai-0.3.1.tar.gz"
  sha256 "84cc2223f16a660517f1b02fa64577fd37badde4c944bd54e5822d8c69aa01c7"
  license "MIT"

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
    system libexec/"bin/python", "-m", "pip", "install", "openai", "pyobjc", "pillow"
  end

  test do
    system "#{bin}/ggai", "--help"
  end
end
