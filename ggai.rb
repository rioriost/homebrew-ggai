class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/96/d9/356304179fce5dc535cb11d4dd8f5f9564019bc27b8ab2e815b9ad456e1e/ggai-0.1.4.tar.gz"
  sha256 "2b020b24b6f50643ab3ea437cf96b060fdc6e9fc87bf747f10a55d4e00721f79"
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
