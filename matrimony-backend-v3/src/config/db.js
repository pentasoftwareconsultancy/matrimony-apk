
import mongoose from "mongoose";
import dns from "dns";

// ✅ Force IPv4 — fixes ECONNREFUSED on Windows
dns.setDefaultResultOrder("ipv4first");

const connectDB = async () => {
  try {
    console.log("🔄 Connecting to MongoDB...");
    console.log(`📍 Using URI: ${process.env.MONGO_URI?.substring(0, 50)}...`);

    const conn = await mongoose.connect(process.env.MONGO_URI, {
      family: 4,                         // ✅ Force IPv4
      serverSelectionTimeoutMS: 15000,   // 15 seconds timeout
      socketTimeoutMS: 45000,
      retryWrites: true,
      w: "majority",
      directConnection: false,           // Allow DNS SRV records
    });

    console.log(`✅ MongoDB Connected: ${conn.connection.host}`);
    console.log(`📊 Database: ${conn.connection.db.databaseName}`);
  } catch (error) {
    console.error(`❌ MongoDB Connection Failed: ${error.message}`);
    console.error(`❌ Error Code: ${error.code}`);
    
    // Provide helpful debugging info
    if (error.message.includes("querySrv")) {
      console.error("💡 DNS/SRV Error - Check:");
      console.error("   1. Internet connection");
      console.error("   2. MongoDB URI format");
      console.error("   3. Network whitelist IP (0.0.0.0/0 added ✓)");
      console.error("   4. Connection string typo");
    }
    
    process.exit(1);
  }
};

export default connectDB;