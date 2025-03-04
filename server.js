// Import required modules
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bcrypt = require('bcrypt'); // Ensure bcrypt is installed: npm install bcrypt
const multer = require('multer');
const path = require('path');

// Initialize Express app
const app = express();
app.use(cors());
app.use(express.json()); // Middleware to parse JSON data
app.use(express.urlencoded({ extended: true })); // Middleware to parse URL-encoded data

// MySQL connection setup
const pool = mysql.createPool({
  host: 'localhost',     // Your database host
  user: 'root',          // Your database username
  password: '9390root',  // Your database password
  database: 'miniproject', // Your database name
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Set up multer for file upload
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage: storage });

// Function to calculate the distance between two coordinates using Haversine formula
const calculateDistance = (lat1, lon1, lat2, lon2) => {
  const R = 6371; // Radius of the Earth in kilometers
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distance in kilometers
};

// Route to fetch nearby scrap shops
app.get('/get_nearby_shops', (req, res) => {
  const userLat = parseFloat(req.query.lat);
  const userLon = parseFloat(req.query.lon);
  const radius = 25; // Set radius in kilometers

  const query = `
    SELECT id, name, address, latitude, longitude, contact_number, description,
    (6371 * ACOS(COS(RADIANS(?)) * COS(RADIANS(latitude)) * COS(RADIANS(longitude) - RADIANS(?)) + 
    SIN(RADIANS(?)) * SIN(RADIANS(latitude)))) AS distance
    FROM scrap_shops
    HAVING distance < ?
    ORDER BY distance ASC;
  `;

  pool.query(query, [userLat, userLon, userLat, radius], (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).send('Server error');
    }
    res.json(results);
  });
});

// API to get available pickup dates for a selected scrap shop
app.get("/get_available_dates", (req, res) => {
  const shopId = req.query.shop_id;
  if (!shopId) {
    return res.status(400).json({ error: "Shop ID is required" });
  }

  const availableDates = [];
  const today = new Date();

  for (let i = 1; i <= 14; i++) { // Next 14 days
    const nextDate = new Date();
    nextDate.setDate(today.getDate() + i);

    if (nextDate.getDay() !== 6 && nextDate.getDay() !== 0) { // Skip weekends
      availableDates.push(nextDate.toISOString().split("T")[0]); // Format YYYY-MM-DD
    }
  }

  res.json(availableDates);
});

// API to schedule a pickup request
app.post('/api/schedule-pickup', (req, res) => {
  const { shopName, shopAddress, shopContact, userId, pickupDate } = req.body;

  if (!shopName || !shopAddress || !shopContact || !userId || !pickupDate) {
    return res.status(400).json({ error: 'All fields are required!' });
  }

  const query = `
    INSERT INTO pickups (shop_name, shop_address, shop_contact, user_id, pickup_date) 
    VALUES (?, ?, ?, ?, ?)
  `;
  const values = [shopName, shopAddress, shopContact, userId, pickupDate];

  db.query(query, values, (err, result) => {
    if (err) {
      console.error('Error inserting data into MySQL:', err);
      return res.status(500).json({ error: 'Database error!' });
    }
    res.json({ message: 'Pickup scheduled successfully!', pickupId: result.insertId });
  });
});

// Signup route
app.post("/signup", async (req, res) => {
  const { username, email, phone, password } = req.body;

  const phoneRegex = /^[0-9]{10,15}$/;
  if (!phoneRegex.test(phone)) {
    return res.status(400).json({ message: "Invalid phone number format" });
  }

  const checkUserQuery = "SELECT * FROM users WHERE email = ? OR phone = ?";
  pool.query(checkUserQuery, [email, phone], async (err, results) => {
    if (err) return res.status(500).json({ message: "Database error" });

    if (results.length > 0) {
      return res.status(400).json({ message: "Email or phone number already in use" });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const insertUserQuery = "INSERT INTO users (username, email, phone, password) VALUES (?, ?, ?, ?)";
    pool.query(insertUserQuery, [username, email, phone, hashedPassword], (err, result) => {
      if (err) return res.status(500).json({ message: "Signup failed" });

      res.status(201).json({ message: "Signup successful! Please login." });
    });
  });
});

// Login route
app.post("/login", (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  const findUserQuery = "SELECT * FROM users WHERE email = ?";
  pool.query(findUserQuery, [email], async (err, results) => {
    if (err) {
      console.error("❌ Error finding user:", err);
      return res.status(500).json({ message: "Database error" });
    }

    if (results.length === 0) {
      return res.status(400).json({ message: "User not found" });
    }

    const user = results[0];
    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    res.status(200).json({ message: "Login successful" });
  });
});

// Endpoint to handle scrap selection form submission
// Endpoint to handle scrap selection form submission
app.post('/save-scrap-selection', upload.single('image'), (req, res) => {
  const { email, items } = req.body; // Get the email and selected items
  const imagePath = req.file ? req.file.path : null; // Save the image path

  const sql = "INSERT INTO ScrapSelections (email, subcategory, image_path) VALUES (?, ?, ?)";
  pool.query(sql, [email, items, imagePath], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ success: false, message: 'Failed to save scrap selection.' });
    }

    res.status(200).json({ success: true, message: 'Scrap selection saved successfully!' });
  });
});


// Serve static files (for uploaded images)
app.use('/uploads', express.static('uploads'));

// Start the server
const port = 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
