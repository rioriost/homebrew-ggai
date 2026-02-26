class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/33/9a/584e58f959e7b4baafc901cd02ad1f6907cc716e6dfbd44bf532ef1bd79d/ggai-0.5.3.tar.gz"
  sha256 "a01bed894184bfc49f6bca1a430b0bdb6786ba2102c91b1204c12cdd8c46c99d"
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
