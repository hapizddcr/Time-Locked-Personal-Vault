import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { network } from "hardhat";

describe("PersonalVault", async () => {
  const { ethers } = await network.connect();

  it("Should deploy successfully", async () => {
    const unlockTime = Math.floor(Date.now() / 1000) + 300;

    const Vault = await ethers.getContractFactory("PersonalVault");
    const vault = await Vault.deploy(unlockTime);

    await vault.waitForDeployment();

    assert.ok(await vault.getAddress());
  });

  it("Should set owner correctly", async () => {
    const [owner] = await ethers.getSigners();

    const unlockTime = Math.floor(Date.now() / 1000) + 300;

    const Vault = await ethers.getContractFactory("PersonalVault");
    const vault = await Vault.deploy(unlockTime);

    await vault.waitForDeployment();

    assert.equal(await vault.owner(), owner.address);
  });

  it("Should accept deposits", async () => {
    const unlockTime = Math.floor(Date.now() / 1000) + 300;

    const Vault = await ethers.getContractFactory("PersonalVault");
    const vault = await Vault.deploy(unlockTime);

    await vault.waitForDeployment();

    await vault.deposit({
      value: ethers.parseEther("1")
    });

    assert.equal(
      await vault.getBalance(),
      ethers.parseEther("1")
    );
  });
});