import React, { useState, useEffect } from "react";
import { ethers } from "ethers";

import ABI from "./utils/WavePortal.json";

import "./styles/App.css";

const App = () => {
  const [currentAccount, setCurrentAccount] = useState("");
  const [allWaves, setAllWaves] = useState([]);
  const [waveCount, setWaveCount] = useState(0);
  const [loading, setLoading] = useState(false);
  const [waveMessage, setWaveMessage] = useState("");

  const contractAddress = "0x00aeCA37220dBEA2c6D2dB3243b7b1CE8fDC9423";
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

  const getWavePortalContract = async () => {
    const { ethereum } = window;
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
      const waves = await wavePortalContract.getAllWaves();
      setWaveCount(count.toNumber());
      let wavesCleaned = [];
      waves.forEach((wave) => {
        wavesCleaned.push({
          address: wave.waver,
          timestamp: new Date(wave.timestamp * 1000),
          message: wave.message,
        });
      });
      setAllWaves(wavesCleaned);
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
      setWaveCount(count.toNumber());
      console.log("Retrieved total wave count...", count.toNumber());
      const waveTxn = await wavePortalContract.wave(waveMessage, { gasLimit: 300000 });
      console.log("Mining...", waveTxn.hash);
      setLoading(true);

      await waveTxn.wait();
      console.log("Mined -- ", waveTxn.hash);
      setLoading(false);
      setWaveMessage("");
      count = await wavePortalContract.getTotalWaves();
      console.log("Retrieved total wave count...", count.toNumber());
      setWaveCount(count.toNumber());
      const allWaves = await wavePortalContract.getAllWaves();
      setAllWaves(allWaves)
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <div className="mainContainer">
      <div className="dataContainer">
        <div className="header">👋 Hey there!</div>
        <input
          onChange={(e) => setWaveMessage(e.target.value)}
          placeholder="Send a message / link"
        />
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
        {allWaves.map((wave, index) => {
          return (
            <div
              key={index}
              style={{
                backgroundColor: "OldLace",
                marginTop: "16px",
                padding: "8px",
              }}
            >
              <div>Address: {wave.address}</div>
              <div>Time: {wave.timestamp.toString()}</div>
              <div>Message: {wave.message}</div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default App;
