class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/e2/7b/57a81f13090f5923203db6e317e9dc41543a164fe1fb5997e3a956e4d924/ggai-0.4.21.tar.gz"
  sha256 "fa9dc93a165efb7153c38467d049e62c076142d1b21f255efb41c28b5ad411af"
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
