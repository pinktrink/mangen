{ pkgs }: let
  inherit (pkgs) symlinkJoin;
  inherit (pkgs.lib.lists) map;
  inherit (pkgs.lib.attrsets) mapAttrs;
in {
  dls = {
    "networking/firehol/fireqos-manual.pdf" = {
      url = "https://firehol.org/fireqos-manual.pdf";
      sha256 = "1dvachsr6xkazhx1vcnvfiij524xgc6kv9a17a2n1119anari04c";
    };
  };

  docs = with pkgs; {
    docs.mans = [
      texinfoInteractive
      man
      mandoc
      pandoc
    ];
    media.mans = [
      ffmpeg
      imagemagick
    ];
    networking = {
      mans = [
        ethtool
        firewalld
        inetutils ipcalc iproute2 iptables
        tcpdump
      ];
      firehol.mans = [ firehol ];
      dns = {
        mans = [
          coredns
          dnsmasq
          dnsutils
          nsd
          unbound
        ];
        djbdns.mans = [ djbdns ];
      };
    };
    nix.mans = [ nix ];
    nixos.mans = [
      nixos-install-tools nixos-option nixos-rebuild
      vulnix
    ];
    system = {
      mans = [
        bash
        findutils
        gnugrep
        pciutils
        readline
        usbutils
      ];
      coreutils.mans = [ coreutils-full ];
      systemd.mans = [ systemd ];
      zsh.mans = [ zsh ];
    };
  };
}
