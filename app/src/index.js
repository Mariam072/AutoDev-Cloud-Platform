const express = require('express');
const mongoose = require('mongoose');

const app = express();
const port = process.env.PORT || 3000;
const mongoUri = process.env.MONGO_URI || 'mongodb://localhost:27017/testdb';

mongoose.connect(mongoUri)
  .then(() => console.log('✅ Connected to MongoDB'))
  .catch(err => console.error('❌ MongoDB connection failed:', err.message));

app.get('/', (req, res) => {
  const status = mongoose.connection.readyState === 1 ? 'yes' : 'no';
  res.json({
    message: 'AutoDev Cloud Platform demo app running!',
    mongoConnected: status,
    timestamp: new Date().toISOString()
  });
});

app.listen(port, () => {
  console.log(`🚀 Server listening on http://localhost:${port}`);
});
