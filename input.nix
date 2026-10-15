{ config, pkgs, ... }: {
  #console.keyMap = "dvorak";
  console.keyMap = "3l";
  # caps2esc interception
  #systemd.services.udevmon =
  #  let intercepts = "${pkgs.interception-tools}/bin"; in
  #    let udevmonConf = pkgs.writeText "udevmon.yaml" ''
  #      SHELL: [${pkgs.runtimeShell}, -c]
  #      ---
  #      - JOB: "${intercepts}/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${intercepts}/uinput -d $DEVNODE"
  #        DEVICE:
  #          EVENTS:
  #            EV_KEY: [KEY_CAPSLOCK, KEY_ESC, KEY_LEFTCTRL]
  #    ''; in {
  #      description = "Interception Tools - udevmon";
  #      wantedBy = [ "multi-user.target" ];
  #      serviceConfig.ExecStart = "${intercepts}/udevmon -c ${udevmonConf}";
  #    };
}
