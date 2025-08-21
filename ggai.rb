class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/29/f3/9facd05a11fa30cb08d04562a4182c8e755bee199dae58b65f0607e67cb9/ggai-0.4.9.tar.gz"
  sha256 "bd291c3f4aa4120cefe389d3b60dd6e17ff6e6c082244c16a83a0197397fd8ae"
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
