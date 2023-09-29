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
    "system/redhat-linux-7-admin-guide.pdf" = {
      url = "https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/pdf/system_administrators_guide/red_hat_enterprise_linux-7-system_administrators_guide-en-us.pdf";
      sha256 = "0kicxwqmb8z06yk75h5grcy31nk00l1crx3caxmwl0awfh9mxkvj";
    };
    "development/languages/haskell/learnyouahaskell.pdf" = {
      url = "http://learnyouahaskell.com/learnyouahaskell.pdf";
      sha256 = "1hzgmqmha4520snb0sj5j26zfbd875inh1c0id5ga2gvwm1vz1aw";
    };
    "development/languages/nix/nix-thesis.pdf" = {
      url = "https://edolstra.github.io/pubs/nspfssd-lisa2004-final.pdf";
      sha256 = "0ffrp64pcrr2f2m9lrmy7c07h5lw2y3c15qnf1r36prgpjqx3l90";
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
      files.mans = [ rsync ];
      rofi.mans = [ rofi ];
      systemd.mans = [ systemd ];
      zsh.mans = [ zsh ];
    };
  };
}
