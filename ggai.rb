class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/31/50/66e4fd3732decd6e2e9817ac3322c1e8b4684253d62fcb9cde4b15805437/ggai-0.5.1.tar.gz"
  sha256 "9cbf7acc828f60e26b54f85ba70dad8b571d0353f3af12f0a18f44987b3b2cc0"
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
