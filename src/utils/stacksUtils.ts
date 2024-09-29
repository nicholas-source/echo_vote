import { StacksMainnet, StacksTestnet } from '@stacks/network';
import { CONFIG } from '../config';

export function getNetwork() {
  return CONFIG.NETWORK === 'mainnet' ? new StacksMainnet() : new StacksTestnet();
}
