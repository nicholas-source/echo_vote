import express from "express";
import {
  castVote,
  getVote,
  getVoteCount,
  getTotalVotes,
} from "../services/voteService";

const router = express.Router();

router.post("/", async (req, res) => {
  try {
    const { proposalId, voteOption } = req.body;
    const result = await castVote(proposalId, voteOption);
    res.status(201).json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get("/:proposalId/:voter", async (req, res) => {
  try {
    const { proposalId, voter } = req.params;
    const vote = await getVote(parseInt(proposalId), voter);
    if (vote) {
      res.json(vote);
    } else {
      res.status(404).json({ error: "Vote not found" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get("/count/:proposalId/:voteOption", async (req, res) => {
  try {
    const { proposalId, voteOption } = req.params;
    const count = await getVoteCount(
      parseInt(proposalId),
      parseInt(voteOption)
    );
    res.json({ count });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get("/total/:proposalId", async (req, res) => {
  try {
    const { proposalId } = req.params;
    const total = await getTotalVotes(parseInt(proposalId));
    res.json({ total });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
