final: prev:
let inherit (final) callPackage;
in {
  qt514 = callPackage ./qt-5/5.14 { };
  qt5 = final.qt514;
  libsForQt514 = prev.recurseIntoAttrs
    (prev.lib.makeScope final.qt514.newScope prev.mkLibsForQt5);
  libsForQt5 = final.libsForQt514;
  python3 = prev.python3.override {
    packageOverrides = python3-self: python3-super: {
      sip = python3-self.callPackage ./sip { };
      pyqt5 = final.libsForQt514.callPackage ./pyqt/5.x.nix {
        pythonPackages = python3-self;
      };
      pyqtwebengine = final.libsForQt514.callPackage ./pyqtwebengine {
        pythonPackages = python3-self;
      };
    };
  };
}
