class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/53/e5/467d08c8801d632a6fd874e39130b155a64fd987373da811fce70de09317/ggai-0.4.7.tar.gz"
  sha256 "ca4d2433ca41c592d41a0795da50dd61047647802230b2a29d3c62502d233fb5"
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
