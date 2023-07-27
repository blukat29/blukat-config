#!/usr/bin/env python3
import json
import os
import re
import shlex
import subprocess
import sys

# pip install codeowners
from codeowners import CodeOwners

def run_cmd(cmd):
    return subprocess.check_output(shlex.split(cmd))

def load_codeowners():
    root_dir = run_cmd("git rev-parse --show-toplevel").decode('utf-8').strip()
    co_path = os.path.join(root_dir, ".github", "CODEOWNERS")
    with open(co_path) as f:
        return CodeOwners(f.read())

def fetch_reviews(num, remote):
    approvers = {}
    page = 1
    while True:
        resp = run_cmd("gh api -H 'Accept: application/vnd.github+json' /repos/{}/pulls/{}/reviews?per_page=100&page={}".format(repo,num,page))
        reviews = json.loads(resp)
        for review in reviews:
            if review['state'] == 'APPROVED':
                user = "@" + review['user']['login']
                approvers[user] = True
        page += 1
        #if len(reviews) == 0:
        if page > 10:
            break
    return approvers

def fetch_pr_files(num, remote):
    filenames = []
    page = 1
    while True:
        j = run_cmd("gh api -H 'Accept: application/vnd.github+json' /repos/{}/pulls/{}/files?per_page=100&page={}".format(repo,num,page))
        for file in json.loads(j):
            filenames.append(file['filename'])
        page += 1
        if page > 10 or j == b'[]':
            break
    return filenames

def print_file(owners, approvers, file):
    file_owners = list(map(lambda x: x[1], owners.of(file)))
    if len(file_owners) == 0:
        print("OK  ", file.ljust(50), [])
        return
    for fo in file_owners:
        if fo in approvers:
            print("OK  ", file.ljust(50), fo)
            return
    print("TODO", file.ljust(50), file_owners)

if __name__ == '__main__':
    if len(sys.argv) >= 2:
        num = sys.argv[1]
    else:
        num = "1708"
    repo = "klaytn/klaytn"
    remote = "upstream"
    print(repo, num, remote)

    owners = load_codeowners()
    approvers = fetch_reviews(num, remote)
    files = fetch_pr_files(num, remote)
    print("approved", list(approvers.keys()))
    for file in files:
        print_file(owners, approvers, file)

