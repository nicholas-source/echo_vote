import { describe, it, expect, beforeEach } from "vitest";
import { Cl } from "@stacks/transactions";

const accounts = simnet.getAccounts();
const deployer = accounts.get("deployer")!;
const wallet1 = accounts.get("wallet_1")!;
const wallet2 = accounts.get("wallet_2")!;

describe("EchoVote", () => {
  const CONTRACT_NAME = "echovote";
});

describe("EchoVote", () => {
  const CONTRACT_NAME = "echovote";

  beforeEach(() => {
    // Reset the blockchain state before each test
    simnet.mineEmptyBlock(1);
  });
});

describe("EchoVote", () => {
  const CONTRACT_NAME = "echovote";

  beforeEach(() => {
    simnet.mineEmptyBlock(1);
  });

  describe("create-proposal", () => {
    it("allows the contract owner to create a proposal", () => {
      const title = "Test Proposal";
      const description = "This is a test proposal";
      const startBlock = simnet.blockHeight + 10;
      const endBlock = startBlock + 100;

      const createProposal = simnet.callPublicFn(
        CONTRACT_NAME,
        "create-proposal",
        [
          Cl.stringUtf8(title),
          Cl.stringUtf8(description),
          Cl.uint(startBlock),
          Cl.uint(endBlock),
        ],
        deployer
      );

      expect(createProposal.result).toBeOk(Cl.uint(1));
    });

    it("prevents non-owners from creating a proposal", () => {
      const createProposal = simnet.callPublicFn(
        CONTRACT_NAME,
        "create-proposal",
        [
          Cl.stringUtf8("Test"),
          Cl.stringUtf8("Test"),
          Cl.uint(simnet.blockHeight + 10),
          Cl.uint(simnet.blockHeight + 100),
        ],
        wallet1
      );

      expect(createProposal.result).toBeErr(Cl.uint(100)); // err-unauthorized
    });

    it("validates proposal parameters", () => {
      const invalidTitle = simnet.callPublicFn(
        CONTRACT_NAME,
        "create-proposal",
        [
          Cl.stringUtf8(""),
          Cl.stringUtf8("Test"),
          Cl.uint(simnet.blockHeight + 10),
          Cl.uint(simnet.blockHeight + 100),
        ],
        deployer
      );
      expect(invalidTitle.result).toBeErr(Cl.uint(104)); // err-invalid-title

      const invalidDescription = simnet.callPublicFn(
        CONTRACT_NAME,
        "create-proposal",
        [
          Cl.stringUtf8("Test"),
          Cl.stringUtf8(""),
          Cl.uint(simnet.blockHeight + 10),
          Cl.uint(simnet.blockHeight + 100),
        ],
        deployer
      );
      expect(invalidDescription.result).toBeErr(Cl.uint(105)); // err-invalid-description

      const invalidBlocks = simnet.callPublicFn(
        CONTRACT_NAME,
        "create-proposal",
        [
          Cl.stringUtf8("Test"),
          Cl.stringUtf8("Test"),
          Cl.uint(simnet.blockHeight - 1),
          Cl.uint(simnet.blockHeight + 100),
        ],
        deployer
      );
      expect(invalidBlocks.result).toBeErr(Cl.uint(106)); // err-invalid-start-block
    });
  });
});
