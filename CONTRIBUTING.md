# Contributing to EchoVote

We welcome contributions of all kinds to EchoVote! Whether it's improving documentation, fixing bugs, adding new features, or writing tests, we appreciate your involvement. This guide outlines the process for contributing and how you can help make EchoVote better.

## How Can You Contribute?

1. **Reporting Bugs**

   - If you find a bug, please open an issue on GitHub with detailed steps to reproduce the issue.
   - Include your environment details, such as Node.js version and OS.
   - Provide any relevant logs or error messages.

2. **Suggesting Features**

   - Have a feature in mind? Open a feature request by creating a GitHub issue with your ideas and use cases.
   - Ensure the feature aligns with the core vision of EchoVote (i.e., decentralized, transparent voting on Bitcoin).

3. **Improving Documentation**

   - If you notice any missing or unclear documentation, please help by improving it.
   - Documentation updates can be submitted as pull requests.

4. **Writing Code**
   - Fix bugs, implement new features, or refactor existing code.
   - Before starting work on a large change, open an issue to discuss it and avoid duplication of effort.
   - Ensure that your code passes existing tests and includes new tests if necessary.

## Getting Started

### 1. Fork the repository

- Navigate to the [EchoVote repository](https://github.com/nicholas-source/echo_vote).
- Click the "Fork" button in the top-right corner to create your copy of the repository.

### 2. Clone your fork

- Clone your forked repository to your local machine:
  ```bash
  git clone https://github.com/nicholas-source/echo_vote.git
  cd echovote
  ```

### 3. Install dependencies

- Ensure you have Node.js installed (v14 or later).
- Install the required packages:
  ```bash
  npm install
  ```

### 4. Create a new branch

- Before starting to work, create a new branch for your changes:
  ```bash
  git checkout -b feature/your-feature-name
  ```

### 5. Implement your changes

- Make sure your code follows the project structure and best practices.
- Include tests where applicable.
- Write clear, concise commit messages.

### 6. Run tests

- Run the test suite to ensure your changes don't break anything:
  ```bash
  npm test
  ```

### 7. Submit a pull request

- Push your changes to your fork:
  ```bash
  git push origin feature/your-feature-name
  ```
- Go to the EchoVote repository on GitHub and open a pull request.
- Include a description of your changes and link any related issues.

## Code Style

Please adhere to the following code style guidelines:

- **Use TypeScript**: All source files should be written in TypeScript (`.ts` files).
- **Linting**: Make sure your code passes linting checks using ESLint. You can run linting with:
  ```bash
  npm run lint
  ```
