class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/3c/cb/e2fababa9df865f8ff8cb2285d207ef895f31d589bb1f2bdffcb3fefe153/ggai-0.4.23.tar.gz"
  sha256 "1cec5041b0f37fa28158ab909e4c8126176418bdf34baac2211d89b431978086"
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
