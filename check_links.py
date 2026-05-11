#!/usr/bin/env python3
import re
import os

BLOG_ENTRY = re.compile("<a href=\"([^\"]+)\">([^<]+)</a>")
HEAD_TITLE = re.compile("<title>([^<]+)</title>")
H1_TITLE = re.compile("<h1>([^<]+)</h1>")

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

print("broken links:", indexed_pages - local_pages)
print("hidden pages:", local_pages - indexed_pages)
