import React, { useState, useEffect, useCallback } from "react";
import { ethers } from "ethers";

import ABI from "./utils/WavePortal.json";

import "./styles/App.css";

const App = () => {
  const [currentAccount, setCurrentAccount] = useState("");
  const [waveCount, setWaveCount] = useState(0);
  const [loading, setLoading] = useState(false);

  const contractAddress = "0x5b80F6cD5EFD1Dd2C8ecBf9485941943E1193f28";
  const contractABI = ABI.abi;

  const checkIfWalletIsConnected = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        console.log("Make sure you have metamask!");
        return;
      } else {
        console.log("We have the ethereum object", ethereum);
      }

      /*
       * Check if we're authorized to access the user's wallet
       */
      const accounts = await ethereum.request({ method: "eth_accounts" });

      if (accounts.length !== 0) {
        const account = accounts[0];
        console.log("Found an authorized account:", account);
        setCurrentAccount(account);
      } else {
        console.log("No authorized account found");
      }
    } catch (error) {
      console.log(error);
    }
  };

  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        alert("Get MetaMask!");
        return;
      }

      const accounts = await ethereum.request({
        method: "eth_requestAccounts",
      });

      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.log(error);
    }
  };

  const { ethereum } = window;
  const getWavePortalContract = async () => {
    if (ethereum) {
      const provider = new ethers.providers.Web3Provider(ethereum);
      const signer = provider.getSigner();
      const wavePortalContract = new ethers.Contract(
        contractAddress,
        contractABI,
        signer
      );
      return wavePortalContract;
    }
  };

  useEffect(() => {
    checkIfWalletIsConnected();
    async function getContract() {
      const wavePortalContract = await getWavePortalContract();
      const count = await wavePortalContract.getTotalWaves();
      setWaveCount(count.toNumber());
      return wavePortalContract;
    }
    getContract();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const wave = async () => {
    try {
      const { ethereum } = window;

      const accounts = await ethereum.request({ method: "eth_accounts" });

      if (accounts.length === 0) {
        await connectWallet();
      }

      const wavePortalContract = await getWavePortalContract();

      let count = await wavePortalContract.getTotalWaves();
      console.log("count", count);
      setWaveCount(count.toNumber());
      console.log("Retrieved total wave count...", count.toNumber());
      const waveTxn = await wavePortalContract.wave();
      console.log("Mining...", waveTxn.hash);
      setLoading(true);

      await waveTxn.wait();
      console.log("Mined -- ", waveTxn.hash);
      setLoading(false);
      count = await wavePortalContract.getTotalWaves();
      console.log("Retrieved total wave count...", count.toNumber());
      setWaveCount(count.toNumber());
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <div className="mainContainer">
      <div className="dataContainer">
        <div className="header">👋 Hey there!</div>
        <button className="waveButton" onClick={() => wave()}>
          Wave at Me
        </button>
        <div>Total Wave Count: {waveCount}</div>
        {loading ? <div>Mining...</div> : null}
        {!currentAccount ? (
          <button className="waveButton" onClick={connectWallet}>
            Connect Wallet
          </button>
        ) : (
          <div className="bio">Connected {currentAccount}</div>
        )}
      </div>
    </div>
  );
};

export default App;
