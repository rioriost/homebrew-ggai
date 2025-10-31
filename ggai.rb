class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/1b/12/654ef2c72925c8ca5158a21f0146c808c96fccd7792b226d4841d0c2732f/ggai-0.4.16.tar.gz"
  sha256 "a7329bf65aca16e670fad632bd8d540bcefec4a49236461188223dd8edc04dc4"
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
