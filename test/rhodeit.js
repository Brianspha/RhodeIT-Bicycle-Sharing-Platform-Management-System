const RhodeITContract = require('Embark/contracts/RhodeIT')
let accounts;

// For documentation please see https://embark.status.im/docs/contracts_testing.html
config({
    //deployment: {
    //  accounts: [
    //    // you can configure custom accounts with a custom balance
    //    // see https://embark.status.im/docs/contracts_testing.html#Configuring-accounts
    //  ]
    //},
    contracts: {
        "RhodeIT": {
            args: []
        }
    }
}, (_err, web3_accounts) => {
    accounts = web3_accounts
});

contract("RhodeIT Deployment", (err) => {
    console.log('accounts: ', accounts)
    console.log(RhodeITContract)
    it('Should add a new student', async () => {
        let results = await RhodeITContract.methods.addUser("g14m1190").send({
            gas: 8000000,
            from: accounts[1]

        })
    })
    it('Should check if a student exists', async () => {
        let exists = await RhodeITContract.methods.userExists().call({
            gas: 8000000
        });
        assert.strictEqual(exists, true)
    })
    it('Should update a students credit', async () => {
        let receipt = await RhodeITContract.methods.updateCredit(accounts[1]).send({
            gas: 8000000,
            from: accounts[1],
            value: web3.utils.toWei('10', 'ether')
        })
    })
    it('Should get the students current ride credits', async () => {
        let balance = await RhodeITContract.methods.getUsercredit().call({
            gas: 8000000,
            from: accounts[1],
        })
        console.log(`balance: ${balance/10**18}`) //@dev could use fromWei 
        assert.strictEqual(parseInt(balance / 10 ** 18) === 10, true)
    })

    it('Should register a docking station', async () => {
        let receipt = await RhodeITContract.methods.registerDockingStation("hamilton", "00", "00").send({
            gas: 8000000,
        })
    })
    it('Should check if a docking station exists', async () => {
        let exists = await RhodeITContract.methods.dockingStationExists("hamilton").call({
            gas: 8000000,
            from: accounts[1],
        })
        assert.strictEqual(exists, true)
    })
    it('Should get a docking station', async () => {
        let dockingStation = await RhodeITContract.methods.getDockingStation("hamilton").call({
            gas: 8000000,
            from: accounts[1]
        })
        var name, lat, long;
        name, lat, long = dockingStation;
        console.log(`name: ${dockingStation[0]}`, dockingStation[0].toString() === "hamilton")
        assert.strictEqual(dockingStation[0].toString() === "hamilton", true)
    })
    it('Should register a new Bicycle', async () => {
        let receipt = await RhodeITContract.methods.registerNewBicycle("bicycle1", "hamilton").send({
            gas: 8000000
        })
    })
    it('Should get a bicycles information', async () => {
        let dockedAt = await RhodeITContract.methods.getBicycle("bicycle1").call({
            gas: 8000000,
            from: accounts[1]
        })
        console.log(`dockedAt ${dockedAt[0]}`)
        assert.strictEqual(dockedAt[0].toString() === "hamilton", true)
    })
    it('Should check if the specified bicycle is docked or not', async () => {
        let docked = await RhodeITContract.methods.bicycleDocked("bicycle1").call({
            gas: 8000000,
            from: accounts[1]
        })
        assert.strictEqual(docked === true, true)
    })
    it('Should rent a new bicycle for specified user', async () => {
        let receipt = await RhodeITContract.methods.rentBicycle("bicycle1", "hamilton").send({
            gas: 8000000,
            from: accounts[1]
        })
    })
    it('Should check if the recently rented bicycle is docked or not', async () => {
        let docked = await RhodeITContract.methods.bicycleDocked("bicycle1").call({
            gas: 8000000,
            from: accounts[1]
        })
        assert.strictEqual(docked === false, true)
    })
    it('Should dock a bicycle', async () => {
        let receipt = await RhodeITContract.methods.dockBicycle("bicycle1", "hamilton").send({
            gas: 8000000,
            from: accounts[1]
        })
    })
    it('Should check if the specified bicycle is docked or not', async () => {
        let docked = await RhodeITContract.methods.bicycleDocked("bicycle1").call({
            gas: 8000000,
            from: accounts[1]
        })
        assert.strictEqual(docked === true, true)
    })

})