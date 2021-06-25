#!/usr/bin/python

import subprocess

num_removed = 0
num_failed = 0
def remove_image(name):
    global num_removed
    global num_failed
    print("Removing " + name)
    try:
        subprocess.check_call(['docker', 'rmi', name])
        num_removed += 1
    except subprocess.CalledProcessError:
        num_failed += 1

def split_name(flat_name):
    '''
    Split a flat name into (REMOTE, NAME, TAG)
    '''
    if flat_name.find('/') >= 0:
        remote, name_tag = flat_name.split('/')
    else:
        remote, name_tag = None, flat_name

    name, tag = name_tag.split(':')

    return remote, name, tag

def dedup_remote(id, flat_names):
    '''
    If the same image has same NAME:TAG, but with different REMOTE/ prefix,
    prefer the shorter (usually the one without REMOTE) one.

    For instance,
      mycompany.azurecr.io/webserver:1.0
      localhost:5000/webserver:1.0
      webserver:1.0
    will be deleted except the last one.
    '''
    buckets = dict()
    for flat_name in flat_names:
        remote, name, tag = split_name(flat_name)
        name_tag = name + ':' + tag

        if buckets.get(name_tag) is None:
            buckets[name_tag] = []
        buckets[name_tag].append(flat_name)

    for name_tag, flat_names in buckets.iteritems():
        if len(flat_names) <= 1:
            continue

        shortest_name = min(flat_names, key=len)
        for flat_name in flat_names:
            if flat_name != shortest_name:
                remove_image(flat_name)

def dedup_tags(id, flat_names):
    '''
    If the same images have same NAME, but different TAG,
    and one of their TAGs are 'latest', then leave only the 'latest'.

    For instance,
      webserver:2791679
      webserver:d39a278
      webserver:latest
    will be deleted except the last one.
    '''
    buckets = dict()
    for flat_name in flat_names:
        remote, name, tag = split_name(flat_name)
        if remote:
            remote_name = remote + '/' + name
        else:
            remote_name = name

        if buckets.get(remote_name) is None:
            buckets[remote_name] = []
        buckets[remote_name].append(flat_name)

    for remote_name, flat_names in buckets.iteritems():
        if len(flat_names) <= 1:
            continue

        shortest_name = min(flat_names, key=len)
        for flat_name in flat_names:
            if flat_name != shortest_name:
                remove_image(flat_name)

raw_output = subprocess.check_output(['docker', 'images'])
images = dict()

for line in raw_output.splitlines():
    words = line.split()
    repo = words[0]
    tag = words[1]
    id = words[2]

    if images.get(id) is None:
        images[id] = []
    images[id].append(repo + ':' + tag)


for id, flat_names in images.iteritems():
    if len(flat_names) == 1:
        continue

    print("Duplicating names for '%s'" % id)
    for name in flat_names:
        print("  " + name)

    dedup_remote(id, flat_names)
    dedup_tags(id, flat_names)


