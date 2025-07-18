const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('path'); // 👈 Agregado

const app = express();
app.use(cors());
app.use(bodyParser.json());

// 👇 Esto sirve los archivos HTML, CSS, JS desde /public
app.use(express.static(path.join(__dirname, 'public')));

// 👇 Configuración de conexión a tu base MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'alumno',
  password: 'alumnoipm',
  database: 'formulario_perfumes'
});

db.connect(err => {
  if (err) {
    console.error('Error de conexión a MySQL:', err);
    return;
  }
  console.log('✅ Conectado a MySQL');
});

// Ruta para guardar datos
app.post('/contacto', (req, res) => {
  const { nombre, correo, mensaje } = req.body;

  const sql = 'INSERT INTO mensajes (nombre, correo, mensaje) VALUES (?, ?, ?)';
  db.query(sql, [nombre, correo, mensaje], (err, result) => {
    if (err) {
      console.error('Error al insertar datos:', err);
      return res.status(500).send('Error al guardar mensaje');
    }
    res.send('✅ Mensaje guardado correctamente');
  });
});

// Iniciar servidor
app.listen(3000, () => {
  console.log('Servidor corriendo en http://localhost:3000');
});
