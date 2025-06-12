class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/bd/d6/2bf89386e79e808be121485f3f1c6757b940f6599fda868f71ca5c0f9ebe/ggai-0.1.6.tar.gz"
  sha256 "8aa0cde6a73561d83d3fa29992f57c7be9219289790aa922d92ee3c97d540a87"
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
