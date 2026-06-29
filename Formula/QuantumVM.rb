class QuantumVM < Formula
  desc "OpenQASM 3.0 language server and runtime"
  homepage "https://github.com/wiji1/QuantumVM"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wiji1/QuantumVM/releases/download/v0.0.8/QuantumVM-aarch64-apple-darwin.tar.xz"
      sha256 "c94d6e7ae8df85dd23992de88f4307b08e80687cf702ed80d628d9e427a4f659"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wiji1/QuantumVM/releases/download/v0.0.8/QuantumVM-x86_64-apple-darwin.tar.xz"
      sha256 "9572c4f78801e32d8fbacc46adce16017b4175da992e5d40582a3a8891216a04"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wiji1/QuantumVM/releases/download/v0.0.8/QuantumVM-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fb2d558080d66a8f5ddf6ee4a3c304bcdd836ed119b3d2250a4a7bf80ed12db8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wiji1/QuantumVM/releases/download/v0.0.8/QuantumVM-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "195354e246b16e22e510c8b6a3e683249dbf7665e60ff3d99aee491be432f6ac"
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
