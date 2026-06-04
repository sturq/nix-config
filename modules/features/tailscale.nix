{ ... }: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    # "client" = join only, "server" = act as exit node, "both" = either.
    useRoutingFeatures = "client";
    # First-time auth: run `sudo tailscale up` once after install.
    # State persists in /var/lib/tailscale.
  };

  # Required on Linux so DNS queries don't bypass the Tailnet resolver.
  networking.firewall.checkReversePath = "loose";
}
