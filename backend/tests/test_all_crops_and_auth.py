import unittest
from backend.app.advisory_engine import advisory_engine

class TestAllCropsAdvisoryEngine(unittest.TestCase):
    def setUp(self):
        self.crops = [
            "Cotton", "Sugarcane", "Rice", "Wheat", "Tomato", "Onion",
            "Potato", "Soybean", "Maize", "Groundnut", "Chickpea",
            "Pigeon Pea", "Banana", "Mango", "Chilli", "Brinjal", "Okra"
        ]

    def test_all_17_crops_have_valid_advisory(self):
        for crop in self.crops:
            # Test Pest problem evaluation
            result_pest = advisory_engine.evaluate("pest_problem", {"crop": crop, "symptom": "borer hole caterpillar"})
            self.assertIsNotNone(result_pest.problem_identified)
            self.assertTrue(len(result_pest.recommended_actions) > 0)
            self.assertIsNotNone(result_pest.weather_consideration)

            # Test Leaf problem evaluation
            result_leaf = advisory_engine.evaluate("leaf_problem", {"crop": crop, "symptom": "yellowing leaves spots"})
            self.assertIsNotNone(result_leaf.problem_identified)
            self.assertTrue(len(result_leaf.recommended_actions) > 0)

    def test_scoring_fallback_tier5(self):
        result = advisory_engine.evaluate("other", {"crop": "Unknown Crop", "symptom": "completely unknown odd symptom"})
        self.assertFalse(result.match_found)
        self.assertEqual(result.rule_id, "expert_escalation_required")
        self.assertIn("Agronomic Review Recommended", result.problem_identified)
        self.assertTrue(len(result.recommended_actions) > 0)

if __name__ == '__main__':
    unittest.main()
