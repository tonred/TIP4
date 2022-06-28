const {
  logContract,
  logger
} = require('./utils');


const main = async () => {
  const [keyPair] = await locklift.keys.getKeyPairs();
  const SampleCollection = await locklift.factory.getAccount('SampleCollection');
  const SampleNFT = await locklift.factory.getAccount('SampleNFT');
  const IndexBasis = await locklift.factory.getAccount('IndexBasis');
  const Index = await locklift.factory.getAccount('Index');
  const SampleStorage = await locklift.factory.getAccount('SampleStorage');

  logger.log('Deploying Sample Collection');
  let sample = await locklift.giver.deployContract({
    contract: SampleCollection,
    constructorParams: {
      nftCode: SampleNFT.code,
      indexBasisCode: IndexBasis.code,
      indexCode: Index.code,
      storageCode: SampleStorage.code,
      admin: '0:0000000000000000000000000000000000000000000000000000000000000000',  // set admin address
    },
    initParams: {},
    keyPair
  }, locklift.utils.convertCrystal(5, 'nano'));
  await logContract(sample);
};


main()
  .then(() => process.exit(0))
  .catch(e => {
    console.log(e);
    process.exit(1);
  });
