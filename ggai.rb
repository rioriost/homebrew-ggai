class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/e5/f2/170bbfdc531ccef525cdcc116f6723b5b65264efd010f04c9256fdbf291e/ggai-0.2.2.tar.gz"
  sha256 "e787b4b3da2769cbfe0c4c73859535af79468f645b05c47289f2a3d73471b88f"
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
