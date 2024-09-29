import express from "express";
import { createProposal, getProposal } from "../services/proposalService";

const router = express.Router();

// Route to create a new proposal
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

// Route to get a proposal by ID
router.get("/:id", async (req, res) => {
  try {
    const proposal = await getProposal(parseInt(req.params.id, 10)); // Fixed bug in proposal ID parsing
    if (proposal) {
      res.json(proposal);
    } else {
      res.status(404).json({ error: "Proposal not found" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Placeholder route for proposals (to be implemented later)
router.get("/", (req, res) => {
  res.status(200).json({ message: "Proposal routes placeholder" });
});

export default router;
