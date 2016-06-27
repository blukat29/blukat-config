import sys

magic = "\177ELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00"

def convert_file(name):
    with open(name, 'rb') as f:
        data = f.read()
    elfname = name + ".elf"
    with open(elfname, 'wb') as g:
        g.write(magic)
        g.write(data[len(magic):])

if __name__ == '__main__':
    for name in sys.argv[1:]:
        convert_file(name)
        print name
