class Quantumvm < Formula
  desc "OpenQASM 3.0 language server and runtime"
  homepage "https://github.com/wiji1/QuantumVM"
  version "0.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wiji1/QuantumVM/releases/download/v0.0.9/QuantumVM-aarch64-apple-darwin.tar.xz"
      sha256 "7d93a673d3c961b16aac7bb8b0017983eea6ba2f358df427c139975279d9aadf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wiji1/QuantumVM/releases/download/v0.0.9/QuantumVM-x86_64-apple-darwin.tar.xz"
      sha256 "e09a48de2c8c62ece2ca0425491f7be78bbd838291b27e05f3c4b45ba25775cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wiji1/QuantumVM/releases/download/v0.0.9/QuantumVM-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bfd65cce7c77f5300dac208e793a53e0272dd7d7d2d96a3b094fa9ca1d804cf0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wiji1/QuantumVM/releases/download/v0.0.9/QuantumVM-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef9b462ffccf34fdb5b2bc215e9f6c9f4d3a4ac4e549250495f5e939f9b93283"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "QuantumVM", "qasm-lsp" if OS.mac? && Hardware::CPU.arm?
    bin.install "QuantumVM", "qasm-lsp" if OS.mac? && Hardware::CPU.intel?
    bin.install "QuantumVM", "qasm-lsp" if OS.linux? && Hardware::CPU.arm?
    bin.install "QuantumVM", "qasm-lsp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
