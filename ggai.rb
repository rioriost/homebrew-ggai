class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/c5/78/803d3317832abc6f2ab6b3abc759ab3a74a68242bad53a561f7035e3b6b2/ggai-0.4.15.tar.gz"
  sha256 "75666bfa63403e083c34f1d0676c9a7a0349800c567ec3dca4996983af6da0a1"
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
