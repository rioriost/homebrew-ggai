class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/61/bf/19d765b04202d635da98a6e4a6697781d8bea085cecda4f9637f2a15fe62/ggai-0.4.3.tar.gz"
  sha256 "90f6dc50673c7165fc0202be3c05b5a556c9f3b54c32344703fac6a8e6025c47"
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
