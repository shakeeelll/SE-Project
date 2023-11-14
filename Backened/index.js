const express=require('express')
const app= express();
const bodyparser= require('body-parser')
cors = require('cors');
const {checkstock}= require('./utils/checkStock');

require('./utils/db');
const login= require('./Routes/signup_route')
app.use(cors());
app.use(bodyparser.json());
app.use(express.json());
const port= 3022;
app.get('/',(req,res)=> {
    res.send('Welcome to site');
});
app.use('/api',login);
app.listen(port,() =>{
    checkstock();
    console.log(`server is listening on port ${port}`);
});
