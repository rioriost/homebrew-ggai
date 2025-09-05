class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/93/a0/211f4aaea40703f05f216bcbdb40f0ec7e0d44cf46daf246d7e640ed5f02/ggai-0.4.10.tar.gz"
  sha256 "b0e39685d688f05c2710edc71c0abd316d135756dfa6d4a61b30939b91e71762"
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
