class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/b8/15/986063542c7e6c353568e63fc97cb77bb101d13f0d9eead1e978161befac/ggai-0.1.5.tar.gz"
  sha256 "32e5b706e28ce45068b1e29535cfb2d41f28ce65375ade7d6e1f6cc0dbd6f97d"
  license "MIT"

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
    system libexec/"bin/python", "-m", "pip", "install", "openai", "pyobjc"
  end

  test do
    system "#{bin}/ggai", "--help"
  end
end
