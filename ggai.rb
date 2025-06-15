class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/36/61/ffd0210b977e1b6c70df82ca2c7c510b52ab85b1e1903f50d66f07795322/ggai-0.4.0.tar.gz"
  sha256 "0f645c83dd8458b9c197307ec48b440e4a9827959d3ad2c815e04c0612c051ba"
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
