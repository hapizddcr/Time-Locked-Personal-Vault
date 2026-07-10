import { network } from "hardhat";

async function main() {
  // Menghubungkan ke network yang dipilih
  const { ethers } = await network.connect();

  // Waktu unlock = 5 menit dari sekarang
  const unlockTime = Math.floor(Date.now() / 1000) + 300;

  console.log("Deploying PersonalVault...");
  console.log("Unlock Time:", unlockTime);

  // Membuat Contract Factory
  const PersonalVault = await ethers.getContractFactory("PersonalVault");

  // Deploy contract
  const personalVault = await PersonalVault.deploy(unlockTime);

  // Menunggu hingga deploy selesai
  await personalVault.waitForDeployment();

  // Menampilkan alamat contract
  console.log("\n✅ Deployment Successful!");
  console.log("Contract Address:", await personalVault.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});