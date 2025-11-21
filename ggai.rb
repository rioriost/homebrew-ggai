class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/d6/42/a29156b952fbd4a495edefe1c1ec418ea4501059ccfe38ace13e279819e1/ggai-0.4.19.tar.gz"
  sha256 "7024193563bcad912d5b8fe336fee6b5aeba9371c7150df171b3f6069da02b43"
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
