const express = require("express");
const mysql = require("mysql2");
const bcrypt = require("bcrypt");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

// Hardcoded environment variables
const ADMIN_EMAIL = "admin@example.com";
const ADMIN_PASSWORD = "admin123"; // Plain text password (will be hashed)
const PORT = 4000;

// MySQL database connection
const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "9390root", // Replace with your MySQL root password
    database: "miniproject", // Replace with your database name
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
});

// Flag to track admin login status (simple solution for demo purposes)
let adminLoggedIn = false;

// Create initial admin user (if not already exists)
async function createInitialAdmin() {
    const hashedPassword = await bcrypt.hash(ADMIN_PASSWORD, 10);

    const checkAdminQuery = "SELECT * FROM admin WHERE email = ?";
    pool.query(checkAdminQuery, [ADMIN_EMAIL], (err, results) => {
        if (err) {
            console.error("Database error:", err);
            return;
        }

        if (results.length === 0) {
            const insertAdminQuery = "INSERT INTO admin (email, password) VALUES (?, ?)";
            pool.query(insertAdminQuery, [ADMIN_EMAIL, hashedPassword], (err) => {
                if (err) {
                    console.error("Error creating admin:", err);
                } else {
                    console.log("Initial admin user created.");
                }
            });
        } else {
            console.log("Admin user already exists.");
        }
    });
}

// Call the function to create the admin on server start
createInitialAdmin();

// User Signup Route
app.post("/signup", async (req, res) => {
    const { username, email, phone, password } = req.body;

    if (!username || !email || !phone || !password) {
        return res.status(400).json({ message: "All fields are required." });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const query = "INSERT INTO users (username, email, phone, password) VALUES (?, ?, ?, ?)";

        pool.query(query, [username, email, phone, hashedPassword], (err) => {
            if (err) {
                if (err.code === "ER_DUP_ENTRY") {
                    return res.status(400).json({ message: "Email already exists." });
                }
                console.error("Signup Error:", err);
                return res.status(500).json({ message: "Server error, try again later." });
            }

            res.status(201).json({ message: "Signup successful!" });
        });
    } catch (error) {
        console.error("Signup Error:", error);
        res.status(500).json({ message: "Server error, try again later." });
    }
});

// User Login Route
app.post("/login", (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: "Email and password are required." });
    }

    const query = "SELECT * FROM users WHERE email = ?";
    pool.query(query, [email], async (err, results) => {
        if (err) {
            console.error("Login Error:", err);
            return res.status(500).json({ message: "Server error, try again later." });
        }

        if (results.length === 0) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        const user = results[0];
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        res.status(200).json({ message: "Login successful!" });
    });
});

// Admin Login Route
app.post("/admin/login", (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: "Email and password are required." });
    }

    const query = "SELECT * FROM admin WHERE email = ?";
    pool.query(query, [email], async (err, results) => {
        if (err) {
            console.error("Admin Login Error:", err);
            return res.status(500).json({ message: "Server error, try again later." });
        }

        if (results.length === 0) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        const admin = results[0];
        const isPasswordValid = await bcrypt.compare(password, admin.password);
        if (!isPasswordValid) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        adminLoggedIn = true; // Admin is logged in
        res.status(200).json({ message: "Admin login successful!" });
    });
});

// Fetch Users for Admin
app.get("/admin/users", (req, res) => {
    if (!adminLoggedIn) {
        return res.status(403).json({ message: "Admin not logged in" });
    }

    const query = "SELECT * FROM users";
    pool.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching users:", err);
            return res.status(500).json({ message: "Server error, try again later." });
        }

        res.status(200).json({ users: results });
    });
});

// Admin Logout Route
app.post("/admin/logout", (req, res) => {
    adminLoggedIn = false;
    res.status(200).json({ message: "Admin logged out successfully." });
});

// Scrap Statistics Route
app.get("/api/scrap-statistics", async (req, res) => {
    try {
        // Query 1: Total Scrap Selections
        const [totalSelections] = await pool.promise().query(
            "SELECT COUNT(*) as total_selections FROM ScrapSelections"
        );

        // Query 2: Selections by Subcategory
        const [selectionsBySubcategory] = await pool.promise().query(
            "SELECT subcategory, COUNT(*) as selection_count FROM ScrapSelections GROUP BY subcategory"
        );

        // Query 3: Most Popular Subcategory
        const [mostPopularSubcategory] = await pool.promise().query(
            "SELECT subcategory, COUNT(*) as selection_count FROM ScrapSelections GROUP BY subcategory ORDER BY selection_count DESC LIMIT 1"
        );

        // Query 4: Recent Selections
        const [recentSelections] = await pool.promise().query(
            "SELECT * FROM ScrapSelections ORDER BY created_at DESC LIMIT 10"
        );

        // Send response
        res.json({
            totalSelections: totalSelections[0].total_selections,
            selectionsBySubcategory: selectionsBySubcategory,
            mostPopularSubcategory: mostPopularSubcategory[0]
                ? mostPopularSubcategory[0].subcategory
                : null,
            recentSelections: recentSelections,
        });
    } catch (error) {
        console.error("Error fetching scrap statistics:", error);
        res.status(500).json({ message: "Error fetching scrap statistics" });
    }
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
