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

def benchmark():
    import time
    milis = lambda: int(round(time.time() * 1000))
    n1 = 1000
    n2 = 50

    t0 = milis()
    for i in range(n1): sock_ip()
    print('sock_ip took %.4f ms per request.' % (float(milis() - t0)/ n1))

    t0 = milis()
    for i in range(n2): host_ip()
    print('host_ip took %.4f ms per request.' % (float(milis() - t0)/ n2))

if __name__ == '__main__':
    if len(sys.argv) > 1:
        benchmark()
    else:
        print(sock_ip() or host_ip() or "Cannot resolve my IP")
