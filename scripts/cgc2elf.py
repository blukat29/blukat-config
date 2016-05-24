import sys

def convert_file(name):
    with open(name, 'rb') as f:
        data = f.read()
    elfname = name + ".elf"
    with open(elfname, 'wb') as g:
        g.write("\x7fELF")
        g.write(data[4:])

if __name__ == '__main__':
    for name in sys.argv[1:]:
        convert_file(name)
        print name
