import os, sys, paramiko

host = os.environ.get('SSH_HOST')
user = os.environ.get('SSH_USER')
password = os.environ.get('SSH_PASS')
if not all([host, user, password]):
    print('Missing SSH_HOST/SSH_USER/SSH_PASS', file=sys.stderr)
    sys.exit(2)
script = sys.stdin.read()
if not script.strip():
    print('No script on stdin', file=sys.stderr)
    sys.exit(2)
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
client.connect(hostname=host, username=user, password=password, timeout=20)
stdin, stdout, stderr = client.exec_command('bash -se')
stdin.write(script)
stdin.channel.shutdown_write()
exit_code = stdout.channel.recv_exit_status()
out = stdout.read().decode('utf-8', errors='replace')
err = stderr.read().decode('utf-8', errors='replace')
if out:
    sys.stdout.buffer.write(out.encode('utf-8', errors='replace'))
if err:
    sys.stderr.buffer.write(err.encode('utf-8', errors='replace'))
client.close()
sys.exit(exit_code)
