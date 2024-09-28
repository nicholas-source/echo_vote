# EchoVote: Amplifying Voices on Bitcoin

EchoVote is a decentralized voting system built on Bitcoin through the Stacks blockchain. It allows for the creation of proposals and secure, transparent voting, leveraging the security and longevity of the Bitcoin network.

## Table of Contents

- [EchoVote: Amplifying Voices on Bitcoin](#echovote-amplifying-voices-on-bitcoin)
	- [Table of Contents](#table-of-contents)
	- [Features](#features)
	- [Project Structure](#project-structure)
	- [Prerequisites](#prerequisites)
	- [Installation](#installation)
	- [Configuration](#configuration)
	- [Usage](#usage)
	- [API Endpoints](#api-endpoints)
	- [Smart Contract](#smart-contract)
	- [Testing](#testing)
	- [Contributing](#contributing)
	- [License](#license)

## Features

- Create and manage proposals
- Secure voting mechanism
- Vote counting and result retrieval
- Built on Stacks blockchain, leveraging Bitcoin's security
- RESTful API for easy integration
- Robust error handling and logging
- Input validation for enhanced security

## Project Structure

```
echovote/
│
├── contracts/
│   └── echovote.clar
│
├── src/
│   ├── config/
│   │   └── index.ts
│   │
│   ├── middleware/
│   │   ├── errorHandler.ts
│   │   ├── notFoundHandler.ts
│   │   └── validateRequest.ts
│   │
│   ├── routes/
│   │   ├── proposalRoutes.ts
│   │   └── voteRoutes.ts
│   │
│   ├── services/
│   │   ├── proposalService.ts
│   │   └── voteService.ts
│   │
│   ├── utils/
│   │   ├── logger.ts
│   │   └── stacksUtils.ts
│   └── index.ts
│
│
├── .env.example
├── .gitignore
├── package.json
├── tsconfig.json
└── README.md
```

## Prerequisites

- Node.js (v14 or later)
- npm or yarn
- Stacks account with testnet STX tokens

## Installation

1. Clone the repository:

   ```
   git clone https://github.com/nicholas-source/echovote.git
   cd echovote
   ```

2. Install dependencies:

   ```
   npm install
   ```

3. Copy the example environment file and update it with your values:
   ```
   cp .env.example .env
   ```

## Configuration

Update the `.env` file with your specific configuration:

```
PORT=3000
NETWORK=testnet
CONTRACT_ADDRESS=your_contract_address
CONTRACT_NAME=echovote
PRIVATE_KEY=your_private_key
```

Make sure to replace `your_contract_address` and `your_private_key` with your actual Stacks contract address and private key.

## Usage

1. Build the TypeScript code:

   ```
   npm run build
   ```

2. Start the server:
   ```
   npm start
   ```

For development with hot-reloading:

```
npm run dev
```

## API Endpoints

- `POST /api/proposals`: Create a new proposal
- `GET /api/proposals/:id`: Get a proposal by ID
- `POST /api/votes`: Cast a vote
- `GET /api/votes/count/:proposalId/:voteOption`: Get vote count for a specific option

For detailed API documentation, refer to the API documentation (TODO: Add link to API docs).

## Smart Contract

The EchoVote smart contract is written in Clarity and provides the following functions:

- `create-proposal`: Create a new proposal
- `vote`: Cast a vote for a proposal
- `close-proposal`: Close a proposal (admin only)
- `get-proposal`: Get proposal details
- `get-vote-count`: Get vote count for a specific option
- `get-total-votes`: Get total votes for a proposal

## Testing

Run the test suite:

```
npm test
```

This will run both unit and integration tests.

## Contributing

We welcome contributions to EchoVote! Please see our [ Guide](CONTRIBUTING.md) for details on how to get started.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

