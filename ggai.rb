class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/f7/d9/4d0756cef400b15c0c456c899095509e797d9cabe32af1af023a7e18cc52/ggai-0.4.8.tar.gz"
  sha256 "94942c2f20c3532336450163553f84171afabdefa3c6e5b98fdfef1562e29c6f"
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
