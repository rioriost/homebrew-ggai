class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/04/14/b276d0a7ede891bc7b35914e441c013eded6dc8b16cf1c7346ebdda5d014/ggai-0.4.18.tar.gz"
  sha256 "51ed080e4158a838ed95aa9fd4ff5b5fc6b932e9ba77bc908ba8ee02e6f8abb2"
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
