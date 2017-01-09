import re
import shlex
import subprocess
import sys

def get_remotes():
    raw = subprocess.check_output(shlex.split('git remote -v'))
    remotes = {}
    for remote in raw.splitlines():
        name, url, rest = remote.split()
        name = name.decode('utf-8')
        url = url.decode('utf-8')
        remotes[name] = url
    return remotes

def set_url(name, old, new):
    print("changing remote url for '{}'".format(name))
    print("from '{}'".format(old))
    print("to '{}'".format(new))
    cmdline = 'git remote set-url {0} {1}'.format(name, new)
    print(cmdline)
    subprocess.check_call(shlex.split(cmdline))

def get_new_url(name, url):
    if url.startswith('http://') or url.startswith('https://'):
        exp = 'https?://' + '([^/@]+@)?([^/]+)/' + '([^/.]+)/' + '([^/.]+)(/|\.git)?'
        match = re.match(exp, url)
        if not match:
            return
        domain = match.group(2)
        user = match.group(3)
        repo = match.group(4)
        new_url = 'git@{0}:{1}/{2}.git'.format(domain, user, repo)
        return new_url
    elif url.startswith('git@'):
        match = re.match('git@([^:]+):([^/]+)/([^.]*)(\.git)?', url)
        if not match:
            return
        domain = match.group(1)
        user = match.group(2)
        repo = match.group(3)
        new_url = 'https://{0}/{1}/{2}.git'.format(domain, user, repo)
        return new_url

def test():
    print(get_new_url('origin', 'https://github.com/user/repo'))
    print(get_new_url('origin', 'git@github.com:user/repo.git'))
    print(get_new_url('origin', 'https://user@bitbucket.org/repo/test.git'))
    print(get_new_url('origin', 'https://bitbucket.org/repo/test.git'))
    print(get_new_url('origin', 'git@bitbucket.org:user/repo.git'))

if __name__ == '__main__':
    remotes = get_remotes()
    name = 'origin'
    url = remotes[name]
    new_url = get_new_url(name, url)
    set_url(name, url, new_url)


