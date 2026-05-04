import express from "express"
import GameDATA from "../models/game.js"

const router=express.Router()

router.get("/getWorld", async(req,res)=>{
    try {
         const GameData=await GameDATA.find()
         res.status(200).json(GameData)
        //res.send(GameData)//
    } catch (error) {
        res.status(500).send(error.mensage)
        console.error(error.mensage)
    }
    
})

router.post("/postWorld",async (req,res)=>{

    try {
        const NewWorld=await GameDATA.insertMany(req.body)
       
  
    res.status(200).json(NewWorld)

    } catch (error) {
        res.status(500).send("ERROR")
        console.error(error)
    }

})

export default router