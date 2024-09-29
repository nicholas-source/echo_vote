import { CONFIG } from "../config";
import {
  callReadOnlyFunction,
  cvToJSON,
  uintCV,
  stringAsciiCV,
} from "@stacks/transactions";
import { getAddressFromPrivateKey } from "@stacks/encryption";
import { getNetwork } from "../utils/stacksUtils";

const network = getNetwork();
const senderAddress = getAddressFromPrivateKey(
  CONFIG.PRIVATE_KEY!,
  network.version
);

// Function to create a new proposal
export async function createProposal(
  title: string,
  description: string,
  startBlock: number,
  endBlock: number
) {
  const functionArgs = [
    stringAsciiCV(title),
    stringAsciiCV(description),
    uintCV(startBlock),
    uintCV(endBlock),
  ];

  const result = await callReadOnlyFunction({
    contractAddress: CONFIG.CONTRACT_ADDRESS!,
    contractName: CONFIG.CONTRACT_NAME!,
    functionName: "create-proposal",
    functionArgs,
    senderAddress,
    network,
  });

  return cvToJSON(result);
}

// Function to get a proposal by ID
export async function getProposal(proposalId: number) {
  const result = await callReadOnlyFunction({
    contractAddress: CONFIG.CONTRACT_ADDRESS!,
    contractName: CONFIG.CONTRACT_NAME!,
    functionName: "get-proposal",
    functionArgs: [uintCV(proposalId)],
    senderAddress,
    network,
  });

  return cvToJSON(result);
}
