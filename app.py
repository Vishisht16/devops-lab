import http.server
import os
import sys
import time

class SimpleHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()
            self.wfile.write(b"ok")
            
        elif self.path == "/hang":
            self.send_response(200)
            self.end_headers()
            # Sleep forever. Since HTTPServer is single-threaded, 
            # this will block the server loop entirely.
            while True:
                time.sleep(3600)
                
        elif self.path == "/crash":
            self.send_response(500)
            self.end_headers()
            self.wfile.write(b"crashing...")
            # Force exit the process immediately with exit code 3
            os._exit(3)
            
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b"not found")

    # Suppress default noisy logging to stdout if desired, or leave default
    def log_message(self, format, *args):
        print(f"[{self.address_string()}] {format % args}")

def run(port=8000):
    server_address = ("", port)
    httpd = http.server.HTTPServer(server_address, SimpleHandler)
    print(f"Server running on port {port}...")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()

if __name__ == "__main__":
    run()