class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/38/f7/9bb26c771ac8b23223e5e842e0d49b451a6bb99fe02b9e52cdda3e95fcf5/ggai-0.4.27.tar.gz"
  sha256 "43792eefc4ce7967823a67b3fa1ddf8021c5553748b2e4baae51e7192f61163b"
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
