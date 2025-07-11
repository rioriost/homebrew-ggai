class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/7d/7f/1c499474fafd81038b2657f85464fdb3470e3075e9bfbbf995d2dd13a2cc/ggai-0.4.5.tar.gz"
  sha256 "3a093972987ff1830167fb4dfd0f4cd65792067974f5ea73cf149cd1a55a9019"
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
