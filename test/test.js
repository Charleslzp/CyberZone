// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");
const abi = require('../contracts/artifacts/Cell.json')

describe("CyberZoneTest", function () {
  var BAYC = 0;
  var CyberZone = 0;
  var Cell=0;
  var CellContractor=0;
  const mintnum=10;
  const ProveKey="0x2d3a8f28d468a4dfe170e0b7d1d45ac3661786e551fc27db32bc10f8f671761d";
  const FileStoreAddress ="11";
  const name="CellBAYC";
  const symbol="CBAYC";
  const totalsupply=100000;
  const decimals = 18;
  

  it("BAYC initial value", async function () {
    const Controctor = await ethers.getContractFactory("BoredApeYachtClub");
    BAYC = await Controctor.deploy("BAYC","BAYC",10000,1);
    await BAYC.deployed();
    console.log('Bayc deployed at:'+ BAYC.address);
  });


   it("BAYC mint", async function () {
    
    await BAYC.mintApe(mintnum);
  
  });

   it("deployd Fractonal ", async function () {
    
    const Controctor = await ethers.getContractFactory("CyberZone");
    CyberZone=await Controctor.deploy("0xA5406b32Dc32bA4397Ca840521f42249C1dFF8aF",70,30,1000);
    await CyberZone.deployed();
    console.log('Cyberzone deployed at:'+ CyberZone.address);

  
    const tx = await CyberZone.CreateNewFactory(BAYC.address,mintnum,ProveKey,FileStoreAddress,name,symbol,totalsupply,decimals);
    const rc = await tx.wait();
    const event = rc.events.find(event => event.event === 'CreateNew');
    Cell = event.args ;
   

    console.log('Cell factory created  at:'+ Cell);


});

 it("aprrove Cell ", async function () {
    

    BAYC.setApprovalForAll(Cell,true);

    /*
    const tx = await CyberZone.CreateNewFactory(BAYC.address,mintnum,ProveKey,FileStoreAddress,name,symbol,totalsupply,decimals);
    const rc = await tx.wait();
    const event = rc.events.find(event => event.event === 'CreateNew');
    Cell = event.args ;
    */

    //console.log('Cell factory created  at:'+ Cell);


});

it("comprex begin ", async function () {
    

    BAYC.setApprovalForAll(Cell,true);

    const provider = new ethers.providers.JsonRpcProvider();

    CellContractor = new ethers.Contract(Cell, abi.abi, provider);

    /*
    const tx = await CyberZone.CreateNewFactory(BAYC.address,mintnum,ProveKey,FileStoreAddress,name,symbol,totalsupply,decimals);
    const rc = await tx.wait();
    const event = rc.events.find(event => event.event === 'CreateNew');
    Cell = event.args ;
    */

    //console.log('Cell factory created  at:'+ Cell);


});