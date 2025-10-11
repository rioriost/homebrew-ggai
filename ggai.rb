class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/5b/c8/6586a5f06fe4e125ad6e494f3743d5c52a060703a01fd2512e8349d2ada5/ggai-0.4.14.tar.gz"
  sha256 "d5e31e737a88f6285a87487230ac7f8a43933a7e84a716fa00d04fa1107bdfa6"
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
