class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/4c/24/6aa211519c74bd7d656bb3f942e2ffd73349d4ae932d4faa55fc770a9409/ggai-0.1.1.tar.gz"
  sha256 "ae475493de1290461742fbcd57a604296ee7ae9f89fd092d2648c898e90690c6"
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
