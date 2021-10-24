const main = async () => {
  //compiles contract and generates necessary files
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
  //creates temporary local ethereum network for contract. Gets destroyed once script completes. Funds contract with 0.1 ETH from wallet
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  });
  //constructor runs when we deploy
  await waveContract.deployed();
  //address is how we find our contract on the blockhain
  console.log('Contract deployed to:', waveContract.address);

  //gets contract balance
  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    'Contract Balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

   const waveTxn = await waveContract.wave('This is wave #1');
   await waveTxn.wait();

   const waveTxn2 = await waveContract.wave('This is wave #2');
   await waveTxn2.wait();

  //gets contract balance after wave
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    'Contract Balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );

  //
  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
