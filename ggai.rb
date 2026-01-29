class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/6e/1e/9caa237204cca306a9e503a1f9d7b9d5a549e0b16fc250eaf21d82a42d57/ggai-0.4.26.tar.gz"
  sha256 "fd1709fafc5f974ca3d97e2749490590ebc86c583059667b31dd22a61b7a4bc3"
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
