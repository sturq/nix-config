{ ... }: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    # "client"  = nur joining
    # "server"  = als exit-node verfügbar
    # "both"    = beide
    useRoutingFeatures = "client";

    # Auto-connect: nach Install einmalig `sudo tailscale up`
    # (Tailscale-State persistiert in /var/lib/tailscale)
  };

  # Tailscale auf Linux braucht das, damit das Netz korrekt funktioniert
  # (verhindert dass DNS-Anfragen den Tailnet-Resolver umgehen)
  networking.firewall.checkReversePath = "loose";
}
