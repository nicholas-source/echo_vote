import { CONFIG } from '../config';
import { callReadOnlyFunction, cvToJSON, uintCV, principalCV } from '@stacks/transactions';
import { getAddressFromPrivateKey } from '@stacks/encryption';
import { getNetwork } from '../utils/stacksUtils';

const network = getNetwork();
const senderAddress = getAddressFromPrivateKey(CONFIG.PRIVATE_KEY!, network.version);

export async function castVote(proposalId: number, voteOption: number) {
  const functionArgs = [
    uintCV(proposalId),
    uintCV(voteOption)
  ];

  const result = await callReadOnlyFunction({
    contractAddress: CONFIG.CONTRACT_ADDRESS!,
    contractName: CONFIG.CONTRACT_NAME!,
    functionName: 'vote',
    functionArgs,
    senderAddress,
    network
  });

  return cvToJSON(result);
}

export async function getVote(proposalId: number, voter: string) {
  const result = await callReadOnlyFunction({
    contractAddress: CONFIG.CONTRACT_ADDRESS!,
    contractName: CONFIG.CONTRACT_NAME!,
    functionName: 'get-vote',
    functionArgs: [uintCV(proposalId), principalCV(voter)],
    senderAddress,
    network
  });

  return cvToJSON(result);
}

export async function getVoteCount(proposalId: number, voteOption: number) {
  const result = await callReadOnlyFunction({
    contractAddress: CONFIG.CONTRACT_ADDRESS!,
    contractName: CONFIG.CONTRACT_NAME!,
    functionName: 'get-vote-count',
    functionArgs: [uintCV(proposalId), uintCV(voteOption)],
    senderAddress,
    network
  });

  return cvToJSON(result);
}

export async function getTotalVotes(proposalId: number) {
  const result = await callReadOnlyFunction({
    contractAddress: CONFIG.CONTRACT_ADDRESS!,
    contractName: CONFIG.CONTRACT_NAME!,
    functionName: 'get-total-votes',
    functionArgs: [uintCV(proposalId)],
    senderAddress,
    network
  });

  return cvToJSON(result);
}
