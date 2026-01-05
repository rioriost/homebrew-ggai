class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/0a/98/c87c7eb08066c829589b1ec71231eb5f3df9a6929681bbaca1c46cdcda28/ggai-0.4.24.tar.gz"
  sha256 "73e4d770fa37bb7db2ebfebe2bc2020df0e7b5ebca399129ded8ea3eda26a363"
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
