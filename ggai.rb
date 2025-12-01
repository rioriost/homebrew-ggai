class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/e1/aa/24b5ba615e81c7c7218e551eba7093aa293178c9131cffa64069445d381f/ggai-0.4.20.tar.gz"
  sha256 "0a4a4cfcf54d62a8d189c383de2671bbb2e76a7efd2a8ad491fa175fee0621c9"
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
