{ ... }: {
  users.users.sturq = {
    isNormalUser = true;
    description = "sturq";
    extraGroups = [ "wheel" "networkmanager" ];
  };
  users.mutableUsers = true;
}
