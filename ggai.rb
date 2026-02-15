class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/6b/96/53624b55fbe19d180bb26c19b4ca2eb222702858873bcef272fc23efe849/ggai-0.5.2.tar.gz"
  sha256 "b45bad174d9cd24fd458cf85622b51b323d0b185ab86b94f33a94957a39da419"
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
