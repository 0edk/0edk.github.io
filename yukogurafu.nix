{
  lib,
  anki-utils,
  fetchFromGitHub,
  pkgs,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "yukogurafu";
  version = "21cb6be";
  src = fetchFromGitHub {
    owner = "0edk";
    repo = "yukogurafu";
    rev = finalAttrs.version;
    hash = "sha256-TJhr/uj4E7CJyZlTH12c3EdvmpPfRr0h0JXsquJcYsY=";
    fetchSubmodules = true;
  };
  meta = {
    description = "Build notes as directed graphs";
    homepage = "https://ankiweb.net/shared/info/665790891";
    license = lib.licenses.agpl3Plus;
  };
  postPatch = ''
    substituteInPlace __init__.py --replace-fail "import graphviz" "import sys; sys.path.insert(0, \"${pkgs.python3Packages.graphviz}/${pkgs.python3.sitePackages}\"); import graphviz"
  '';
})
