const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Notre petite route de test
app.get('/', (req, res) => {
    res.send('Bravo Jeanny ! Ton tout premier serveur Node/Express tourne comme une horloge. 🚀');
});

app.listen(PORT, () => {
    console.log(`Le serveur écoute sur : http://localhost:${PORT}`);
});