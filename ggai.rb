class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/a8/37/8c2762d0132bb9303a73e69cdbbf9ea80938c94f9c2c298a7ff6d50cfe6e/ggai-0.2.1.tar.gz"
  sha256 "132be5f1c202367b2277274b215b398a7bf9f6c4e3086ad0d32968aa33ffd61b"
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
