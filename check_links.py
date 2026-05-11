#!/usr/bin/env python3
import re
import os

BLOG_ENTRY = re.compile("<a href=\"([^\"]+)\">([^<]+)</a>")
HEAD_TITLE = re.compile("<title>([^<]+)</title>")
H1_TITLE = re.compile("<h1>([^<]+)</h1>")
FOOTER = re.compile("<footer><i>Updated [-0-9]+</i>"
    "( - <a href=\"[^\"]+\">[^<]+</a>)?")
PIC_REF = re.compile("<img src=\"([^\"]+)\"")

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
for filename in os.listdir():
    if filename.endswith(".html"):
        if filename != "index.html":
            with open(filename, "r") as f:
                page_text = f.read()
            head_title = HEAD_TITLE.search(page_text)
            if not head_title:
                print(f"no <title> in {filename}")
            h1_title = H1_TITLE.search(page_text)
            if not h1_title:
                print(f"no <h1> in {filename}")
            if head_title and h1_title:
                if head_title.group(1) == h1_title.group(1):
                    local_pages.add((filename, head_title.group(1)))
                else:
                    print(f"mismatched titles in {filename}")
            footer = FOOTER.search(page_text)
            if not footer:
                print(f"no footer in {filename}")
            for pic in PIC_REF.finditer(page_text):
                pics_used.add(pic.group(1))
    elif os.path.splitext(filename)[1] in [".gif", ".jpg", ".png", ".svg"]:
        pics_avail.add(filename)

print("broken links:", indexed_pages - local_pages)
print("hidden pages:", local_pages - indexed_pages)
print("broken images:", pics_used - pics_avail)
print("unused images:", pics_avail - pics_used)
