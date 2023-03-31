const express = require('express');
const { exec } = require('child_process');

const app = express();
const port = 3001;

app.use(express.urlencoded({ extended: false }));
app.use(express.static('public'));

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

app.post('/', (req, res) => {
  const { message } = req.body;
  const command = `bash ./blob.sh "${message}"`;

  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`);
      return;
    }
    console.log(`stdout: ${stdout}`);
    res.send(stdout);
  });
});

app.listen(port, () => {
  console.log(`Server is listening at http://localhost:${port}`);
});

