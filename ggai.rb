class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/1a/76/c73b40ac4e97846dfa62fa28f8952444657eeced7be02063c78550fab55f/ggai-0.4.4.tar.gz"
  sha256 "1311f4359d0f760ae1fc9dacd0daf8095b2c86c747e0ab9d4fece0bd51e20942"
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
