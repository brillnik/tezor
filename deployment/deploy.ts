import { TezosToolkit } from '@taquito/taquito';
import { InMemorySigner } from '@taquito/signer';
const Tezos = new TezosToolkit('https://rpcalpha.tzbeta.net');
const signer = new InMemorySigner("edskRugHWLyCeMDQEb84rL4hzcRUDTNVzV2Ntwp6HN5f11G6Rzru4WhFXCQ87ZNra14gPkttDTyMPmBVV6e5qqVetNTyEgKgkz");

const genericMultisigJSONfile = require('../build/FA1_2.json');
const genericMultisigJSONstorage=require('../build/FA1_2_storage.json')

Tezos.setProvider({ signer: signer });

const deploy = async () => {
  

    Tezos.setProvider({ signer: signer });
  
    try {
      const { hash, contractAddress } = await Tezos.contract.originate({
        code: genericMultisigJSONfile,
        init: genericMultisigJSONstorage,
      });
  
      console.log("Successfully deployed contract");
      console.log(`>> Transaction hash: ${hash}`);
      console.log(`>> Contract address: ${contractAddress}`);
    } catch (error) {
      console.log(error);
    }
  };
  
  deploy();
  