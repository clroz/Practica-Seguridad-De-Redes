// Executes the selected read-only audit script on the PNETLab host.
const { Client } = require('ssh2');
const fs = require('fs');
if (!process.argv[2] || !process.env.PNET_AUDIT_PASSWORD) {
  console.error('Provide a script path and PNET_AUDIT_PASSWORD in the environment.');
  process.exit(1);
}
const command = fs.readFileSync(process.argv[2], 'utf8');
const conn = new Client();
conn.on('ready', () => conn.exec(command, (err, stream) => {
  if (err) {
    console.error(err.message);
    conn.end();
    process.exitCode = 1;
    return;
  }
  stream.on('data', data => process.stdout.write(data));
  stream.stderr.on('data', data => process.stderr.write(data));
  stream.on('close', code => { process.exitCode = code || 0; conn.end(); });
}));
conn.on('error', err => { console.error(err.message); process.exitCode = 1; });
conn.connect({
  host: process.env.PNET_AUDIT_HOST || '192.168.22.132',
  username: 'root',
  password: process.env.PNET_AUDIT_PASSWORD,
  readyTimeout: 15000
});
