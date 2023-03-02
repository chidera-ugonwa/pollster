//using artifacts.require to import the SmartContract
const Voting = artifacts.require("Voting");
contract("Voting", () => {
  it("Testing smart contract", async () => {
    const voting = await Voting.deployed();
//fire the voteAlpha function
    await voting.voteAlpha();

//fire the getTotalVotesAlpha function
    const result = await voting.getTotalVotesAlpha();
    console.log(result);
  });
});