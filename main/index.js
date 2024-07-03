const WebSocket = require('ws');
const readline = require('readline');
const wss = new WebSocket.Server({ port: 5656 });
const clients = [];
const ngrok = require("@ngrok/ngrok");
const fs = require('fs');

// Settings

const ngrokauth = ''
const repoOwner = '';
const repoName = '';
const filePath = 'ngrok-url.txt';
const token = '';
// -- end


// Read the file names.txt
function getname() {
  return new Promise((resolve, reject) => {
    fs.readFile('names.txt', 'utf8', (err, data) => {
      if (err) {
        reject(err);
      } else {
        const lines = data.split('\n');
        const randomNumber = Math.floor(Math.random() * 4949) + 1;
        const name = lines[randomNumber - 1];
        resolve(name);
      }
    });
  });
}


(async function() {
  // Establish connectivity
  await ngrok.authtoken(ngrokauth);
  const listener = await ngrok.forward({ proto: 'tcp', addr: 5656 });

  // Output ngrok url to console
  console.log(`Ingress established at: ${listener.url()}`);

  // Edit the file on your GitHub page

  const headers = {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  };

  try {
    const response = await fetch(`https://api.github.com/repos/${repoOwner}/${repoName}/contents/${filePath}`, {
      method: 'GET',
      headers
    });

    if (response.ok) {
      const fileData = await response.json();
      const sha = fileData.sha;
      const fileContent = listener.url();
      const data = {
        'message': 'Update ngrok URL',
        'content': Buffer.from(fileContent, 'utf8').toString('base64'),
        'sha': sha
      };

      const editResponse = await fetch(`https://api.github.com/repos/${repoOwner}/${repoName}/contents/${filePath}`, {
        method: 'PUT',
        headers,
        body: JSON.stringify(data)
      });

      if (editResponse.ok) {
        console.log(`Ngrok URL updated on GitHub page: ${filePath}`);
      } else {
        console.error(`Error updating ngrok URL on GitHub page: ${editResponse.statusText}`);
      }
    } else {
      console.log(`File not found: ${filePath}`);
    }
  } catch (error) {
    console.error(`Error updating ngrok URL on GitHub page: ${error}`);
  }
})();

wss.on('connection', (ws) => {
  clients.push(ws);
  getname().then((name) => {
  ws.send(`os.setComputerLabel("${name}")`);
});

  ws.on('message', (message) => {
    console.log(`T: ${message}`); // Prefix with "T: " for turtle responses
  });

  ws.on('close', () => {
    clients.splice(clients.indexOf(ws), 1);
  });
});

function broadcast(message) {
  clients.forEach((client) => {
    client.send(message.toString());
  });
}

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});
rl.prompt(',');
rl.on('line', (input) => {
  if (input.trim()!== '') {
    broadcast(`${input}`); // Prefix with "U: " for user inputs
  }
  rl.prompt();
}).on('close', () => {
  process.exit(0);
});
