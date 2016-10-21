#!/usr/bin/env python
import json
import os
import random
import subprocess
import sys

try:
    from http.server import HTTPServer as http_server
except ImportError:
    from SocketServer import TCPServer as http_server
try:
    from http.server import SimpleHTTPRequestHandler as http_handler
except ImportError:
    from SimpleHTTPServer import SimpleHTTPRequestHandler as http_handler

template="""
<html><head>
<style>
%s
</style>
</head>
<body>
<div class="markdown-body" id="result"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/markdown-it/7.0.0/markdown-it.min.js"></script>
<script>
var md = markdownit();
var raw = %s;
var result = md.render(raw);
document.getElementById("result").innerHTML = result;
</script>
</body></html>"""

g_style = ""
p = os.path
curr_dir = p.dirname(p.realpath(__file__))
css_name = p.join(curr_dir, 'github-markdown.css')
with open(css_name, 'r') as f:
    g_style = f.read()

g_fname = ""

class MarkdownHandler(http_handler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/html")
        self.end_headers()
        with open(g_fname, 'r') as f:
            html = template % (g_style, json.dumps(f.read()))
            self.wfile.write(bytes(html.encode('utf-8')))

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("markd <fname> <port>")
        exit(1)

    g_fname = sys.argv[1]
    if len(sys.argv) < 3:
        port = random.randint(20000,60000)
    else:
        port = int(sys.argv[2])
    handler = MarkdownHandler
    http_server.allow_reuse_address = True
    server = http_server(('', port), handler)
    myip = subprocess.check_output(['python', os.path.join(curr_dir, 'myip.py')]).rstrip('\n')
    print("Serving at port http://%s:%d/.." % (myip, port))
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    server.shutdown()
    server.server_close()

