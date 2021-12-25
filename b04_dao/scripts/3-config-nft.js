import sdk from "./1-initialize-sdk.js";
import { readFileSync } from "fs";

const bundleDrop = sdk.getBundleDropModule(
  "0x8962962EEaE64571e6a7C4F2c02B1540c64ac77c",
);

(async () => {
  try {
    await bundleDrop.createBatch([
      {
        name: "2022 Quarter",
        description: "This NFT will give you access to Mars.College!",
        image: readFileSync("scripts/assets/patch.jpg"),
      },
    ]);
    console.log("✅ Successfully created a new NFT in the drop!");
  } catch (error) {
    console.error("failed to create the new NFT", error);
  }
})()