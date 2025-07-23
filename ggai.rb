class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/dd/39/924e8b924e280672fd501613e5165bc3d20ae1865da59c9c3d26d2e94056/ggai-0.4.6.tar.gz"
  sha256 "12e096551e79c2f5eae82ad830339a3c3674f4a035873a3a2c4b94d1693d8158"
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
