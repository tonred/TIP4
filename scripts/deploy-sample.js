const {
  logContract,
  logger
} = require('./utils');


const main = async () => {
  const [keyPair] = await locklift.keys.getKeyPairs();
  const SampleFullCollection = await locklift.factory.getAccount('SampleFullCollection');
  const SampleFullNFT = await locklift.factory.getAccount('SampleFullNFT');
  const IndexBasis = await locklift.factory.getAccount('IndexBasis');
  const Index = await locklift.factory.getAccount('Index');
  const SampleFullStorage = await locklift.factory.getAccount('SampleFullStorage');

  logger.log('Deploying Sample Collection');
  let sample = await locklift.giver.deployContract({
    contract: SampleFullCollection,
    constructorParams: {
      nftCode: SampleFullNFT.code,
      indexBasisCode: IndexBasis.code,
      indexCode: Index.code,
      storageCode: SampleFullStorage.code,
      json: "{\"type\": \"Basic Collection\", \"name\": \"Test Collection\"}",
      admin: '0:0000000000000000000000000000000000000000000000000000000000000000',  // set admin address
    },
    initParams: {
      // _randomNonce: 0,  // to use same address for collection
    },
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
