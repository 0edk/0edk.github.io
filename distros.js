function shuffle(list) {
    for (let i = list.length - 1; i >= 1; i--) {
        const j = Math.floor((i + 1) * Math.random());
        [list[i], list[j]] = [list[j], list[i]];
    }
}

const DISTROS = [
    "NixOS",
    "Arch Linux",
    "Raspberry Pi OS",
    "Debian",
    "Devuan",
    "Kali Linux",
    "Ubuntu",
    "Fedora Linux",
    "Parrot OS",
    "PureOS",
    "ALT Linux",
    "Gentoo Linux",
    "openSUSE",
    "Manjaro",
    "Guix",
    "Parabola GNU/Linux",
    "Trisquel GNU/Linux",
    "Alpine Linux",
    "Slackware",
    "Void Linux",
    "Mageia",
    "CachyOS",
    "Pop!OS",
    "Zorin OS",
    "EndeavourOS",
];
shuffle(DISTROS);
const SUFFIXES = ["GNU/Linux", "Linux", "OS"];
const EXT_SUFFIXES = ["none"].concat(SUFFIXES);

function elemText(tag, text) {
    const e = document.createElement(tag);
    e.textContent = text;
    return e;
}

function classify(fullName) {
    for (const s of SUFFIXES) {
        if (fullName.endsWith(s)) {
            return [s, fullName.split(s)[0].trim()];
        }
    }
    return ["none", fullName.replaceAll(" ", "")];
}

const qlist = document.getElementById("qlist");
const header = document.createElement("tr");
header.append(elemText("th", ""));
header.append(elemText("th", "(no suffix)"));
for (const s of SUFFIXES) {
    header.append(elemText("th", "-" + s));
}
qlist.append(header);
const answers = [];
const cruxes = [];
for (const d of DISTROS) {
    const row = document.createElement("tr");
    const [truth, crux] = classify(d);
    answers.push(truth);
    cruxes.push(crux);
    row.append(elemText("td", crux));
    for (const s of EXT_SUFFIXES) {
        const radio = document.createElement("input");
        radio.type = "radio";
        radio.name = crux;
        radio.value = s;
        const label = document.createElement("label");
        label.append(radio);
        label.style.width = "100%";
        label.style.height = "100%";
        label.style.display = "block";
        const wrapper = document.createElement("td");
        wrapper.append(label);
        wrapper.style.padding = 0;
        row.append(wrapper);
    }
    qlist.append(row);
}

function enscore() {
    let max = 0;
    let score = 0;
    for (const i in DISTROS) {
        for (const radio of document.getElementsByName(cruxes[i])) {
            if (radio.checked) {
                max++;
                if (radio.value == answers[i]) {
                    score++;
                }
            }
        }
    }
    return [score, max];
}

document.getElementById("getscore").onclick = _ => {
    const [score, max] = enscore();
    document.getElementById("numscore").textContent = `${score}/${max}`;
    document.getElementById("ignored").textContent = DISTROS.length - max;
    document.getElementById("showscore").style.display = "block";
};

document.getElementById("copy").onclick = _ => {
    const [score, _max] = enscore();
    navigator.clipboard.writeText(
        `I know the full names of ${score}/${DISTROS.length} Linux distros\n`
        + window.location
    );
};
