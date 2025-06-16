class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/2d/20/6478088c312b926fd061915d018f346463a529cbe9ad60a5c7a794c78a6c/ggai-0.4.1.tar.gz"
  sha256 "b29330a56aa915d72ec37c7fbe96991abc4f650591cd5b17cd1e7d5b39b2c192"
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
