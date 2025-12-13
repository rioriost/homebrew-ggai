class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/14/98/3ca2630448fd19d9fe7cac6fe066298892b994ac73699c6390560857bb86/ggai-0.4.22.tar.gz"
  sha256 "f727fc896066f7faecbc5ddf83abc2852b1950a6d4a3530e6544ad92bd5f4b3c"
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
