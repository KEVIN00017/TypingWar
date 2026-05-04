import express from 'express';
import dotenv from 'dotenv';
import router from './controllers/routes.js'
import ConnectDB from './models/connection.js'
dotenv.config()
const PORT=process.env.PORT || 3000
const App=express()
await ConnectDB()
App.use(express.json())
App.use("/api",router)
App.get("/",(req,res)=>{
    res.send("SARVE")
})

App.listen(PORT,()=>{
    console.log(`Servidor Rodando na porte ${PORT}` )
}) 