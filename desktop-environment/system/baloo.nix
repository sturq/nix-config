{ ... }: {
  # Baloo file indexing — sits at 200-400 MB after walking a home dir,
  # Dolphin search falls back to find/locate which is plenty.
  environment.etc."xdg/baloofilerc".text = ''
    [Basic Settings]
    Indexing-Enabled=false
  '';
}
