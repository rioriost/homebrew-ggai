class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/03/fa/c951347070488f1405ed556dfed142c38b7e88c65d14df4436795c30ac98/ggai-0.4.13.tar.gz"
  sha256 "e490d55f012eb3af989ce101cea0be5432837666979439482434e462c2e90a57"
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
