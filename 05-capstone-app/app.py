#!/usr/bin/env python3
"""
KCNA Capstone Health & Configuration Microservice
Exposes:
  - GET /               -> Returns configuration & masked secrets
  - GET /healthz        -> Liveness & Startup health check (returns 200 OK or 500)
  - GET /ready          -> Readiness health check (returns 200 OK or 503)
  - POST/GET /fail-live -> Toggles liveness failure
  - POST/GET /fail-ready-> Toggles readiness failure
"""

import os
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

IS_ALIVE = True
IS_READY = True

class HealthConfigHandler(BaseHTTPRequestHandler):
    def _send_response(self, status_code, content_type, body):
        self.send_response(status_code)
        self.send_header('Content-Type', content_type)
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body.encode('utf-8'))

    def do_GET(self):
        global IS_ALIVE, IS_READY

        if self.path == '/healthz':
            if IS_ALIVE:
                self._send_response(200, 'text/plain', 'OK: Application is alive\n')
            else:
                self._send_response(500, 'text/plain', 'ERROR: Application is failing liveness!\n')

        elif self.path == '/ready':
            if IS_READY:
                self._send_response(200, 'text/plain', 'OK: Ready to serve traffic\n')
            else:
                self._send_response(503, 'text/plain', 'UNAVAILABLE: Pod is not ready for traffic\n')

        elif self.path == '/fail-live':
            IS_ALIVE = False
            self._send_response(200, 'text/plain', 'Triggered liveness failure. Kubelet will kill this container!\n')

        elif self.path == '/fail-ready':
            IS_READY = False
            self._send_response(200, 'text/plain', 'Triggered readiness failure. Pod will be removed from Endpoints!\n')

        elif self.path == '/restore':
            IS_ALIVE = True
            IS_READY = True
            self._send_response(200, 'text/plain', 'Restored all probes to healthy.\n')

        else:
            # Home: Render JSON containing ConfigMap & Secret status
            db_pass = os.getenv('DB_PASSWORD', 'not-set')
            masked_pass = db_pass[:3] + '***' if len(db_pass) > 3 else '***'

            response_data = {
                "message": "KCNA Configuration & Health Capstone Microservice",
                "status": {
                    "is_alive": IS_ALIVE,
                    "is_ready": IS_READY
                },
                "configmap_data": {
                    "app_env": os.getenv('APP_ENV', 'unknown'),
                    "log_level": os.getenv('LOG_LEVEL', 'unknown'),
                    "app_port": os.getenv('PORT', '8080'),
                },
                "secret_data": {
                    "db_user": os.getenv('DB_USER', 'unknown'),
                    "db_password_masked": masked_pass,
                    "api_key_set": bool(os.getenv('API_KEY'))
                }
            }
            self._send_response(200, 'application/json', json.dumps(response_data, indent=2) + '\n')

def run():
    port = int(os.getenv('PORT', 8080))
    server_address = ('0.0.0.0', port)
    httpd = HTTPServer(server_address, HealthConfigHandler)
    print(f"Server starting on port {port}...", flush=True)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()

if __name__ == '__main__':
    run()
