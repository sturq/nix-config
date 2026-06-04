{ pkgs, ... }: {
  # Misc CLI utilities. Lumped because they're all just packages
  # with zero per-tool configuration.
  home.packages = with pkgs; [
    # File / text
    ripgrep
    fd
    eza               # ls replacement
    bat               # cat replacement
    tree
    jq
    yq

    # Process / monitoring
    htop
    btop

    # Network
    curl
    wget
    nmap

    # Dev workflow
    just              # task runner

    # Crypto
    age
    ssh-to-age
  ];
}
