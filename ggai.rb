class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/b5/35/4e786b00e24e3b63d376bb5c1eae6385ed6101a3dc63849641f90f8fcf24/ggai-0.3.0.tar.gz"
  sha256 "1545d27a5a63e1186efbf3bef1244e87a5d216783519923610f52d9f36b2a061"
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
