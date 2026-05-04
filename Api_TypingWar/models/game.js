   import mongoose from "mongoose"
   
   const UserSchema= new mongoose.Schema({
        WorldPT:String,
        WorldEN:String,
        LVL:String
    })

    const GameDATA=mongoose.model("Game",UserSchema)
    export default GameDATA  