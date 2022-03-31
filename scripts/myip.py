import socket
import sys
# http://stackoverflow.com/a/1267524
# Original one-liner:
# print([l for l in ([ip for ip in socket.gethostbyname_ex(socket.gethostname())[2] if not ip.startswith("127.")][:1], [[(s.connect(("8.8.8.8", 53)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][0][1]]) if l][0][0])

def sock_ip():
    '''Generally faster.'''
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 53))
    except OSError:
        return None
    ip, port = s.getsockname()
    s.close()
    return ip

def host_ip():
    try:
        ips = socket.gethostbyname_ex(socket.gethostname())[2]
    except socket.gaierror:
        return None
    for ip in ips:
        if not ip.startswith('127.'):
            return ip
    return None

def httpbin_ip():
    import json
    try:
        from urllib.request import urlopen
    except ImportError:
        from urllib2 import urlopen
    r = urlopen('http://httpbin.org/ip')
    return json.loads(r.read().decode('utf-8'))['origin']

def benchmark():

    import time
    milis = lambda: int(round(time.time() * 1000))
    def do_test(f, n):
        t0 = milis()
        for i in range(n): f()
        dt = float(milis() - t0) / n
        print('%s (%s) took %.4fms per request.' % (f.__code__.co_name, f(), dt))

    do_test(sock_ip, 1000)
    do_test(host_ip, 50)
    do_test(httpbin_ip, 3)

if __name__ == '__main__':
    usage='''\
myip.py [-sntb]
  -s: connect to 8.8.8.8:53 and use getsockname(). Generally fastest.
  -n: use gethostbyname(gethostname()). Usually don't work.
  -t: get http://httpbin.ip. Fetches public IP, but slow.
  -b: Benchmark above methods.'''
    if len(sys.argv) > 1:
        opt = sys.argv[1]
        if len(opt) != 2 or opt[0] != '-' or (opt[1] not in 'sntb'):
            print(usage)
            exit(1)
        if opt[1] == 's':
            print(sock_ip())
        elif opt[1] == 'n':
            print(host_ip())
        elif opt[1] == 't':
            print(httpbin_ip())
        elif opt[1] == 'b':
            benchmark()
    else:
        print(sock_ip() or host_ip() or httpbin_ip() or "Cannot resolve my IP")
