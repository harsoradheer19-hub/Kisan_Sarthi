import urllib.request
import json

base_url = 'http://127.0.0.1:8000'

def run_live_tests():
    print("=========================================")
    print("   KISAN SARTHI LIVE SYSTEM TEST RUN    ")
    print("=========================================")

    # 1. Health check
    res = urllib.request.urlopen(f"{base_url}/health")
    health = json.loads(res.read().decode())
    print(f"1. Health Check: STATUS = {health['status']} | ENGINE = {health['advisory_engine']}")
    assert health['status'] == 'healthy'

    # 2. Categories API
    res = urllib.request.urlopen(f"{base_url}/api/v1/categories")
    cats = json.loads(res.read().decode())
    print(f"2. Problem Categories: {len(cats)} categories retrieved")
    assert len(cats) >= 6

    # 3. Crops Knowledge Base
    res = urllib.request.urlopen(f"{base_url}/api/v1/crops")
    crops = json.loads(res.read().decode())
    print(f"3. Crops Knowledge Base: {len(crops)} crops available")
    assert len(crops) >= 17

    # 4. Cotton Advisory Test
    payload = {
        "category_id": "pest_problem",
        "answers": {"crop": "Cotton", "symptom": "Whiteflies under leaf surface curling"},
        "location": "Nashik, Maharashtra"
    }
    req = urllib.request.Request(f"{base_url}/api/v1/advisory/evaluate", data=json.dumps(payload).encode(), headers={'Content-Type': 'application/json'})
    adv_res = json.loads(urllib.request.urlopen(req).read().decode())
    print(f"4. Cotton Advisory: Match={adv_res['match_found']} | Problem: {adv_res['problem_identified']}")
    assert adv_res['match_found'] is True

    # 5. Tomato Advisory Test
    payload = {
        "category_id": "leaf_problem",
        "answers": {"crop": "Tomato", "symptom": "Early blight target spot concentric rings"},
        "location": "Nashik, Maharashtra"
    }
    req = urllib.request.Request(f"{base_url}/api/v1/advisory/evaluate", data=json.dumps(payload).encode(), headers={'Content-Type': 'application/json'})
    adv_res_tom = json.loads(urllib.request.urlopen(req).read().decode())
    print(f"5. Tomato Advisory: Match={adv_res_tom['match_found']} | Problem: {adv_res_tom['problem_identified']}")
    assert adv_res_tom['match_found'] is True

    # 6. Fallback Tier-5 Advisory Test (Unusual Symptom)
    payload = {
        "category_id": "other",
        "answers": {"crop": "Dragonfruit", "symptom": "Unusual purple neon spots"},
        "location": "Nashik, Maharashtra"
    }
    req = urllib.request.Request(f"{base_url}/api/v1/advisory/evaluate", data=json.dumps(payload).encode(), headers={'Content-Type': 'application/json'})
    adv_res_fallback = json.loads(urllib.request.urlopen(req).read().decode())
    print(f"6. Tier-5 Fallback: Match={adv_res_fallback['match_found']} | Problem: {adv_res_fallback['problem_identified']}")
    assert adv_res_fallback['rule_id'] == "expert_escalation_required"

    # 7. Weather API Test
    res = urllib.request.urlopen(f"{base_url}/api/v1/weather?location=Nashik")
    weather = json.loads(res.read().decode())
    print(f"7. GPS Weather API: {weather['location']} | Temp: {weather['temperature']}°C | Cond: {weather['condition']} | Rain Prob: {weather['rain_probability']}%")

    print("\n=========================================")
    print("  [SUCCESS] ALL 7 SYSTEM TESTS PASSED SUCCESSFULLY! ")
    print("=========================================")

if __name__ == '__main__':
    run_live_tests()
