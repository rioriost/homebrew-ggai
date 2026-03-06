class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/eb/8c/a72dd680263d10ee6696899243ad350ea7867c0d730e2b5d2f2d1efe19d3/ggai-0.5.4.tar.gz"
  sha256 "7500f2408dbcb6d38f6fe8e03b0cad6f17c93322bd36f4f4df0f6620a319ac55"
  license "MIT"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
    system libexec/"bin/python", "-m", "pip", "install", "openai", "pyobjc", "pillow"
  end

  test do
    system "#{bin}/ggai", "--help"
  end
end
