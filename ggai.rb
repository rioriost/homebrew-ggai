class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/43/e6/535bc9035bb72c43033b95ceaa290626e4a3839706547ab40b3099cbd4e1/ggai-0.2.0.tar.gz"
  sha256 "6e41a2d8005d0e9eff9f4fde24af1fd7ddfd83f8a317849b446779dfabae64cf"
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
