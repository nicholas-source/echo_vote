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
