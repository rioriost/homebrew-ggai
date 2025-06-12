class Ggai < Formula
  include Language::Python::Virtualenv

  desc "Helper for GeoGuessr training using OpenAI"
  homepage "https://github.com/rioriost/homebrew-ggai/"
  url "https://files.pythonhosted.org/packages/cf/a6/7f5d74b7a8e7abafaf0a5a48797748a521bb9e984aa57fe7a23e9702f93a/ggai-0.1.3.tar.gz"
  sha256 "51f601ef89eeb42fa32737864f94685bee59c4a285dfb0c56095b2921b0f820c"
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
