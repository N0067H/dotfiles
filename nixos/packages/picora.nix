{ lib, stdenv, fetchurl, autoPatchelfHook, wrapGAppsHook3
, gtk3, webkitgtk_4_1, libsoup_3, glib, cairo, gdk-pixbuf, dbus
, libayatana-appindicator, xdotool, libGL, libxkbcommon
, xorg, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "picora";
  version = "0.1.10";

  src = fetchurl {
    url = "https://github.com/Party4Bread/Picora/releases/download/v${version}/picora-${version}-linux-x86_64.tar.gz";
    hash = "sha256-+LfM+MWAlmpmYBPDuswzrmIPI3ZM1n2phH1+fch+OKY=";
  };

  nativeBuildInputs = [ autoPatchelfHook wrapGAppsHook3 makeWrapper ];
  buildInputs = [
    stdenv.cc.cc.lib gtk3 webkitgtk_4_1 libsoup_3 glib cairo gdk-pixbuf dbus
    libayatana-appindicator xdotool libGL libxkbcommon
    xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr
  ];

  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 picora $out/bin/picora
    install -Dm644 app.picora.desktop.desktop $out/share/applications/app.picora.desktop.desktop
    install -Dm644 app.picora.desktop.svg $out/share/icons/hicolor/scalable/apps/app.picora.desktop.svg
    mkdir -p $out/share/doc/picora
    cp -r README.md OFL.txt docs licenses $out/share/doc/picora/
    runHook postInstall
  '';

  # The tray, X11 input, and graphics libraries are loaded dynamically.
  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
      libayatana-appindicator xdotool libGL libxkbcommon
      xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr
    ]}")
  '';

  meta = {
    description = "Desktop sticker picker";
    homepage = "https://github.com/Party4Bread/Picora";
    platforms = [ "x86_64-linux" ];
    mainProgram = "picora";
  };
}
