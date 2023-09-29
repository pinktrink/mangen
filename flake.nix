{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";

    inherit (pkgs) symlinkJoin runCommand fetchurl writeShellScript;
    inherit (pkgs.stdenv) mkDerivation;
    inherit (pkgs.lib.lists) map;
    inherit (pkgs.lib.strings) concatStringsSep replaceStrings;
    inherit (pkgs.lib.attrsets) mapAttrsRecursive foldlAttrs mapAttrs concatMapAttrs isAttrs;

    d = x: builtins.trace x x;

    formats = {
      asciidoc = "adoc";
      markdown = "md";
      gfm = "gf.md";
      latex = "tex";
      epub = "epub";
      docbook = "dbk";
      mediawiki = "mwk";
      rtf = "rtf";
      rst = "rst";
    };

    flattenMans = s: let
      unnest = p: s: concatMapAttrs (n: v: if (isAttrs v) then
        unnest (p ++ [ n ]) v
      else
        { "${concatStringsSep "/" p}" = v; }
      ) s;
    in unnest [ ] s;

    all = import ./docs.nix { inherit pkgs; };
    dls = mapAttrs (_: v: fetchurl v) all.dls;
    docs = mapAttrs (n: v: symlinkJoin {
      name = n;
      paths = map (x: x.man or x) v;
    }) (flattenMans all.docs);

    buildPaths = foldlAttrs (a: n: v: a + ''
      buildPaths[${n}]=${v}
    '') "" docs;
    dlPaths = foldlAttrs (a: n: v: a + ''
      dlPaths[${n}]="${v}"
    '') "" dls;
    builder = c: d ''
      declare -A buildPaths
      ${buildPaths}
      declare -A dlPaths
      ${dlPaths}
      mkdir -p "$out"
      touch $out/failed
      for i in "''${!buildPaths[@]}"; do
        mkdir -p "$out/$i"
        for j in $(find "''${buildPaths[$i]}/share/man" -not -type d); do
          f=$(basename "$j")
          if [[ $(zcat "$j" | wc -l) -le 1 ]]; then
            continue
          fi
          if ! ${c}; then
            echo $j >> "$out/failed"
          fi
        done
      done
      for i in "''${!dlPaths[@]}"; do
        mkdir -p "$out"/"$(dirname "$i")"
        echo cp "''${dlPaths[$i]}" "$out/$i"
        cp "''${dlPaths[$i]}" "$out/$i"
      done
    '';
  in {
    packages.x86_64-linux = mapAttrs (n: v: runCommand "mangen-${n}" {
      nativeBuildInputs = with pkgs; [ coreutils pandoc gzip findutils wget ];
    } (builder ''gunzip -c "$j" | pandoc -f man -t ${n} -o "$out/$i/''${f%.*}.${v}"'')) formats // {
      pdf = runCommand "mangen-pdf" {
        nativeBuildInputs = with pkgs; [ coreutils man findutils ghostscript wget ];
      } (builder ''man -t "$j" | ps2pdf - "$out/$i/''${f%.*}.pdf"'');
    };
    apps.x86_64-linux = mapAttrs (n: v: {
      type = "app";
      program = (writeShellScript "sync-mans-${n}" ''
        ${pkgs.rsync}/bin/rsync -au --delete "${self.packages.x86_64-linux.${n}}/" "/home/chloe/etc/obsidian/docs"
      '').outPath;
    }) (formats // { pdf = "pdf"; });
  };
}
