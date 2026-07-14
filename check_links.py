#!/usr/bin/env python3
import collections
import datetime
import os
import re
import sys

script_mode: str = ""
if len(sys.argv) == 1:
    script_mode = "lint"
if len(sys.argv) == 3:
    new_filename = sys.argv[1]
    new_title = sys.argv[2]
    if " " in new_filename and " " not in new_title:
        new_filename, new_title = new_title, new_filename
    if "." not in new_filename:
        new_filename += ".html"
    if new_filename.endswith(".html"):
        script_mode = "new"
if not script_mode:
    print("invalid usage")
    sys.exit(1)

BLOG_ENTRY = re.compile("<a href=\"([^\"]+)\">([^<]+)</a>")
PAGE_START = re.compile("^<!.*</h1>", flags=re.MULTILINE | re.DOTALL)
HEAD_TITLE = re.compile("<title>([^<]+)</title>")
H1_TITLE = re.compile("<h1>([^<]+)</h1>")
PAGE_END = re.compile("^ *<footer>.*</html>", flags=re.MULTILINE | re.DOTALL)
DATE_LIKE = re.compile("[0-9][-0-9]+")
FOOTER = re.compile("<footer><i>Updated [-0-9]+</i>"
    "( - <a href=\"[^\"]+\">[^<]+</a>)?")
FULL_PIC_REF = re.compile("<img ([^>]+)")
PIC_SOURCE = re.compile("src=\"([^\"]+)\"")
PIC_ALT = re.compile("alt=\"([^\"]+)\"")

with open("index.html", "r") as f:
    indexed_pages: set[tuple[str, str]] = set()
    found_blog = False
    for line in f:
        if found_blog:
            entry = BLOG_ENTRY.search(line)
            if entry:
                indexed_pages.add((entry.group(1), entry.group(2)))
            elif "</ul>" in line:
                break
        if "<h2>Blog</h2>" in line:
            found_blog = True
    else:
        print("blog section not found")

local_pages: set[tuple[str, str]] = set()
pics_used: set[str] = set()
pics_avail: set[str] = set()
headers: collections.Counter[str] = collections.Counter()
footers: collections.Counter[str] = collections.Counter()
for filename in os.listdir():
    if filename.endswith(".html"):
        with open(filename, "r") as f:
            page_text = f.read()
        raw_header = PAGE_START.search(page_text)
        is_redirect = False
        if raw_header:
            full_header = H1_TITLE.sub("<h1>TITLE</h1>", HEAD_TITLE.sub(
                "<title>TITLE</title>", raw_header.group(0)
            ))
            headers[full_header] += 1
        elif "http-equiv=\"refresh\"" in page_text:
            is_redirect = True
        else:
            print(f"no proper header in {filename}")
        head_title = HEAD_TITLE.search(page_text)
        if not head_title:
            print(f"no <title> in {filename}")
        h1_title = H1_TITLE.search(page_text)
        if not h1_title and not is_redirect:
            print(f"no <h1> in {filename}")
        if head_title and h1_title:
            if head_title.group(1) == h1_title.group(1):
                local_pages.add((filename, head_title.group(1)))
            else:
                print(f"mismatched titles in {filename}")
        if not is_redirect:
            full_footer: str = DATE_LIKE.sub("DATE", PAGE_END.search(
                page_text
            ).group(0))
            footers[full_footer] += 1
        footer = FOOTER.search(page_text)
        if not footer and not is_redirect:
            print(f"no footer in {filename}")
        for pic in FULL_PIC_REF.finditer(page_text):
            attrs = pic.group(1)
            src = PIC_SOURCE.search(attrs)
            if src:
                pics_used.add(src.group(1))
            else:
                print(f"no src=... in {pic.group(0)} of {filename}")
            alt = PIC_ALT.search(attrs)
            if not alt:
                print(f"no alt=... in {pic.group(0)} of {filename}")
    elif os.path.splitext(filename)[1] in [".gif", ".jpg", ".png", ".svg"]:
        pics_avail.add(filename)

if script_mode == "lint":
    print("broken links:", indexed_pages - local_pages)
    print("hidden pages:", local_pages - indexed_pages)
    print("broken images:", pics_used - pics_avail)
    print("unused images:", pics_avail - pics_used)
    print("header styles:", (+headers).most_common())
    print("footer styles:", (+footers).most_common())
elif script_mode == "new":
    with open(new_filename, "x") as f:
        f.write(headers.most_common(1)[0][0].replace("TITLE", new_title))
        f.write("\n")
        today = str(datetime.date.today())
        f.write(footers.most_common(1)[0][0].replace("DATE", today))
    editor = os.environ["EDITOR"]
    os.execvp(editor, [editor, new_filename])
