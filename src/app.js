
const express = require('express');
const { engine } = require('express-handlebars');
const morgan = require('morgan');
const helmet = require('helmet');
const path = require('node:path');

const app = express();

// Seguridad HTTP
app.use(helmet());

// Logger de peticiones
app.use(morgan('dev'));

// Procesamiento de datos
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Archivos estáticos
app.use(express.static(path.join(__dirname, '../public')));

// Configuración de Handlebars
app.engine('handlebars', engine({
  defaultLayout: 'main',
}));

app.set('view engine', 'handlebars');
app.set('views', path.join(__dirname, 'views'));

// Ruta principal
app.get('/', (req, res) => {
  res.render('home', {
    title: 'Academia Platform',
    message: 'Nuestra plataforma educativa está funcionando',
  });
});

module.exports = app;
