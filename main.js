function e(a, o, c, l) {
    return a.substring(0, o) + (l > 0 ?
        a.substring(o + l, c) + a.substring(o, o + l) :
        a.substring(c + l, c) + a.substring(o, c + l)) + a.substring(c);
}

function d(t, o) {
    return (t % o + o) % o;
}

function n(t, r, l, c) {
    return String.fromCodePoint(t + d(r.codePointAt(l) - t + c, 95));
}

function u(a) {
    let r = a;
    for (let o = 0; o < a.length; o += 4) {
        r = e(r, o, o + 3, -2);
    }
    a = "";
    for (let o = r.length - 1; o >= 0; o--) {
        a = n(32, r, o, -20 - 3 * o) + a;
    }
    return a;
}

document.getElementsByClassName("boc")[1].onclick = ev => {
    const c = u('$"x*`53.G81PSh{G') + "r" + u("{%%'<-Q781]:N");
    const l = document.getElementsByClassName("boc")[0]
    if (!l.textContent.includes("@")) {
        l.textContent += " at " + c.split(":")[1];
    }
    window.open(c);
}
