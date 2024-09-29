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

router.get("/:id", async (req, res) => {
  try {
    const proposal = await getProposal(parseInt(req.params.id));
    if (proposal) {
      res.json(proposal);
    } else {
      res.status(404).json({ error: "Proposal not found" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
