import express from "express";
import { createProposal, getProposal } from "../services/proposalService";

const router = express.Router();

router.post("/", async (req, res) => {
  try {
    const { title, description, startBlock, endBlock } = req.body;
    const result = await createProposal(
      title,
      description,
      startBlock,
      endBlock
    );
    res.status(201).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
