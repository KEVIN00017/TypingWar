import express from 'express';
import dotenv from 'dotenv';
import router from './controllers/routes.js'
import ConnectDB from './models/connection.js'
import Date from 'date/Date';

dotenv.config()

const PORT=process.env.PORT || 3000
const App=express()
const date= new Date()

await ConnectDB()

App.use(express.json())

App.use("/api",router)


App.get("/",(req,res)=>{
    res.send("Server ON")
})

App.listen(PORT,()=>{
    console.log(`Servidor Rodando na porta ${PORT} , Data atual:${date.getDate().toString()}/${date.getMonth().toString()}/${date.getFullYear().toString()}` )
})    