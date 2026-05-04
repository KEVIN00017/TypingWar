import mongoose from "mongoose";

const ConnectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.IP);
    console.log("MongoDB conectado em:", conn.connection.host);
  } catch (error) {
    console.error("Erro real:", error.message);
    process.exit(1);
  }
};

export default ConnectDB;