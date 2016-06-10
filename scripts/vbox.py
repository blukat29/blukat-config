from __future__ import print_function
import subprocess
import sys
import re

def do_vbox_cmd(cmd):
    p = subprocess.Popen(["VBoxManage"] + cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    if err and len(err):
        msg = "Failed to execute command " + ' '.join(cmd)
        msg += "\n" + err
        raise Exception(err)
    else:
        return out
class VBoxVM(object):
    def __init__(self, name, uid):
        self.name = name
        self.uid = uid
    def state(self):
        info = do_vbox_cmd(["showvminfo", self.uid])
        for line in info.splitlines():
            if line.startswith("State:"):
                return re.search("State:\s+(.*)", line).group(1)
    def start(self, headless=False):
        cmd = ["startvm", self.uid]
        if headless:
            cmd += ["--type", "headless"]
        do_vbox_cmd(cmd)

def get_vm_list():
    raw_result = do_vbox_cmd(["list", "vms"])
    if not raw_result:
        return None
    list_vms_re = re.compile(r'\"(\S+)\" \{([\w-]+)\}')
    vms = []
    for idx, line in enumerate(raw_result.splitlines()):
        name, uid = list_vms_re.match(line).groups()
        vms.append(VBoxVM(name, uid))
    return vms

def lookup_vm(vms, name_or_idx):
    for vm in vms:
        if vm.name == name_or_idx:
            return vm
    try:
        idx = int(name_or_idx)
        return vms[idx]
    except ValueError:
        return None
    except IndexError:
        return None

def die(msg):
    print(msg)
    exit(1)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("vbox list")
        print("vbox start <vm_or_idx>")
        print("vbox headless <vm_or_idx>")
        exit(1)

    vms = get_vm_list()
    if sys.argv[1] == "list":
        for idx, vm in enumerate(vms):
            print(idx, vm.name, vm.uid, vm.state())

    elif sys.argv[1] == "start" or sys.argv[1] == "headless":
        vm = lookup_vm(vms, sys.argv[2])
        if not vm:
            die("No such vm")
        vm.start(headless=(sys.argv[1] == "headless"))

    else:
        die("Unknown command '%s'" % sys.argv[1])
