class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/0f/8e/8dcbcb80afcd539da8639853ebe52d6e8c5978976e5a11fad9740a284fe4/ggai-0.4.2.tar.gz"
  sha256 "65a9eb344be2aa4447d58e441b3f4d85947f687ef690c7aed1a691d2af04b078"
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
