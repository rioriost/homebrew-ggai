class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/5a/b4/9f99154c4be7172d719e266ecc5926fad8321d94fcfec496714b90c5773c/ggai-0.4.25.tar.gz"
  sha256 "5054dd8853a6e50a5b07b8bbe1c49dee1f9b0d61f34fc8ebe68b92c9518e41b3"
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
