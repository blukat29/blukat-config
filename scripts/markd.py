#!/usr/bin/env python
import os
import sys
import random
import json
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
css_name = p.join(p.dirname(p.realpath(__file__)), 'github-markdown.css')
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
            self.wfile.write(bytes(html))

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print "markd <fname> <port>"
        exit(1)

    g_fname = sys.argv[1]
    if len(sys.argv) < 3:
        port = random.randint(20000,60000)
    else:
        port = int(sys.argv[2])
    handler = MarkdownHandler
    http_server.allow_reuse_address = True
    server = http_server(('', port), handler)
    print "Serving at port http://localhost:%d/.." % port
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    server.shutdown()
    server.server_close()
