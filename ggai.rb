class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/93/01/92010e6a5dcc8a80197642c78380f3a860023b89f855a95d1e0c4eed9ef5/ggai-0.4.17.tar.gz"
  sha256 "48267f17963dc8f12fbf966bd6274b3a12d9ce66d0b268c38aeced37e8b8432e"
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
