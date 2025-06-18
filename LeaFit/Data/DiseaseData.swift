//
//  Disease.swift
//  LeaFit
//
//  Created by Arin Juan Sari on 17/06/25.
//

import Foundation

let diseases: [Disease] = [
    Disease(
        diseaseId: "anthracnose",
        nameDisease: "Anthracnose",
        explanation: "A fungal disease caused by Colletotrichum species. It thrives in warm, humid conditions and spreads quickly when aloe leaves stay wet for long periods.",
        prevention: [
            Prevention(
                preventionTitle: "Move to Good Air Circulation Area",
                preventionDetail: "This disease often appears in a humid environment with poor air circulation. Place the plant in a bright location and have good air circulation."
            ),
            Prevention(
                preventionTitle: "Prune Infected Leaves",
                preventionDetail: "Use a sterile tool to cut leaves that show symptoms of brown/black spots. Do not throw it in the planting area, because it can be contagious."
            ),
            Prevention(
                preventionTitle: "Use Organic or Chemical Fungicides",
                preventionDetail: "Fungicides made from copper or sulfur can help control the spread of disease. Follow the dosage and instructions."
            ),
            Prevention(
                preventionTitle: "Reduce Temporary Watering",
                preventionDetail: "Soil conditions that are too humid can aggravate fungal infections. Allow the soil to partially dry before the next watering."
            ),
            Prevention(
                preventionTitle: "Keep the Planting Environment Clean",
                preventionDetail: "Clean dead or fallen leaves around the plant, because it can be a place for mold to grow."
            )
        ],
        watering: [
            Watering(
                wateringCondition: [
                    WateringCondition(
                        condition: "Hot/dry season",
                        wateringFrequency: "Once every 10 days",
                        wateringVolume: "Water sufficiently, avoid standing water",
                        wateringNote: "Ensure the soil surface is somewhat dry before watering again"
                    ),
                    WateringCondition(
                        condition: "Rainy/humid season",
                        wateringFrequency: "Once every 2–3 weeks",
                        wateringVolume: "Very little, just enough to maintain moisture",
                        wateringNote: "Do not water if the soil is still moist"
                    ),
                    WateringCondition(
                        condition: "Indoor",
                        wateringFrequency: "Once every 2 weeks",
                        wateringVolume: "Just enough to moisten the soil",
                        wateringNote: "Use your finger or a skewer to check the soil condition"
                    )
                ],
                wateringTips: "✅ Tips: Use a porous growing medium such as coarse sand + burnt husks/perlite to ensure fast drying."
            )
        ],
        drying: [
            Drying(
                dryingCondition: [
                    DryingCondition(
                        plantCondition: "Infected with fungal disease",
                        dryingDuration: "2–4 hours/day",
                        dryingBestTime: "Morning (07:00–09:00)",
                        dryingNote: "Do not expose for too long immediately, avoid harsh direct sunlight"
                    ),
                    DryingCondition(
                        plantCondition: "Recovery after treatment",
                        dryingDuration: "3–5 hours/day",
                        dryingBestTime: "Morning to midday",
                        dryingNote: "Increase duration gradually, monitor condition changes"
                    )
                ],
                dryingTips: "⚠️ Avoid: Environments that are too humid and have no light — this can worsen fungal infections."
            )
        ],
        colorHex: "F40654"
    ),
    Disease(
        diseaseId: "sunburn",
        nameDisease: "Sunburn",
        explanation: "Caused by excessive exposure to direct sunlight, especially when Aloe is moved too quickly from shade to sun. Sunburn isn’t a pathogen but a physical stress injury.",
        prevention: [
            Prevention(
                preventionTitle: "Move to a Shadier Place",
                preventionDetail: "Avoid direct midday sunlight. Places that get morning light are safer."
            ),
            Prevention(
                preventionTitle: "Don't Trim Directly",
                preventionDetail: "Allow the burned leaves to dry naturally. If it is cut too fast, it can cause additional stress."
            ),
            Prevention(
                preventionTitle: "Adjust Gradually",
                preventionDetail: "If you want to get used to a brighter place, do it gradually (for example, increase the duration of drying every day)."
            ),
            Prevention(
                preventionTitle: "Make Sure Proper Watering",
                preventionDetail: "Aloe vera that is stressed because of the sun can also be dehydrated. Water when the soil is completely dry, not too often."
            )
        ],
        watering: [
            Watering(
                wateringCondition: [
                    WateringCondition(
                        condition: "Hot/dry season",
                        wateringFrequency: "Once every 7–10 days",
                        wateringVolume: "Water until it runs out the bottom of the pot, then drain",
                        wateringNote: "Do not let water pool"
                    ),
                    WateringCondition(
                        condition: "Rainy/humid season",
                        wateringFrequency: "Once every 2–3 weeks",
                        wateringVolume: "Very little, just enough to moisten the growing media",
                        wateringNote: "Ensure soil is dry before watering"
                    ),
                    WateringCondition(
                        condition: "Indoor (inside room)",
                        wateringFrequency: "Once every 2 weeks",
                        wateringVolume: "Just enough to moisten",
                        wateringNote: "Check soil moisture using finger or skewer"
                    )
                ],
                wateringTips: "✅ Tips: Use porous growing media such as a mix of soil + coarse sand + burnt husks/perlite."
            )
        ],
        drying: [
            Drying(
                dryingCondition: [
                    DryingCondition(
                        plantCondition: "New plant / moved from indoors",
                        dryingDuration: "Start with 1–2 hours/day",
                        dryingBestTime: "Morning (07:00–09:00)",
                        dryingNote: "Gradually increase exposure duration"
                    ),
                    DryingCondition(
                        plantCondition: "Healthy & well-adapted plant",
                        dryingDuration: "4–6 hours/day",
                        dryingBestTime: "Morning to noon (07:00–11:00)",
                        dryingNote: "Avoid intense midday sun (11:00–15:00)"
                    ),
                    DryingCondition(
                        plantCondition: "Indoor without direct sunlight",
                        dryingDuration: "No need for direct sun",
                        dryingBestTime: "Place near a bright window",
                        dryingNote: "Occasional weekly sun exposure helps photosynthesis"
                    )
                ],
                dryingTips: "⚠️ Avoid: Sudden prolonged exposure — this is a common cause of sunburn."
            )
        ],
        colorHex: "7D28F7"
    ),
    Disease(
        diseaseId: "rot",
        nameDisease: "Rot",
        explanation: "A disease caused by overwatering or poor drainage, leading to fungal or bacterial infection, particularly from pathogens like Pythium or Fusarium.",
        prevention: [
            Prevention(
                preventionTitle: "Unplug and Check the Root",
                preventionDetail: "Remove the plant from the pot and check the roots. Rotten roots will be blackish brown, Mushy, and smells bad."
            ),
            Prevention(
                preventionTitle: "Trim the Rotten Roots",
                preventionDetail: "Use sterile scissors to remove the damaged root part. Cut until you find Healthy root tissue (white or beige)."
            ),
            Prevention(
                preventionTitle: "Dry the plant",
                preventionDetail: "Allow the pruned roots to dry in a shaded and windy place for 1–2 days Before replanting."
            ),
            Prevention(
                preventionTitle: "Change Planting Media and Pot",
                preventionDetail: "Use a new planting medium that is porous and quick to dry (soil + sand + husk/perlit). Make sure The pot has enough drainage holes."
            ),
            Prevention(
                preventionTitle: "Reduce Watering and Monitor",
                preventionDetail: "After replanting, do not water immediately. Wait 2-3 days for the root wound to close, then water a little. Observe the condition of the plant periodically."
            )
        ],
        watering: [
            Watering(
                wateringCondition:
                    [
                        WateringCondition(
                            condition: "After root pruning",
                            wateringFrequency: "2–3 days after replanting",
                            wateringVolume: "Very little, just enough to moisten",
                            wateringNote: "Ensure the media is completely dry before the first watering"
                        ),
                        WateringCondition(
                            condition: "Recovery process (week 1–3)",
                            wateringFrequency: "Once every 10–14 days",
                            wateringVolume: "A bit around the root area",
                            wateringNote: "Avoid pooling water, do not soak the entire media")
                        ,
                        WateringCondition(
                            condition: "After recovery (>3 weeks)",
                            wateringFrequency: "Once every 7–10 days",
                            wateringVolume: "Water thoroughly, then drain",
                            wateringNote: "Ensure the pot has good drainage"
                        )
                    ],
                wateringTips: "✅ Tips: Use terracotta pots, which absorb excess moisture more easily."
            )
        ],
        drying: [
            Drying(
                dryingCondition: [
                    DryingCondition(
                        plantCondition: "Newly replanted",
                        dryingDuration: "1–2 hours/day",
                        dryingBestTime: "Morning (07:00–09:00)",
                        dryingNote: "Do not expose too long while roots are still healing"
                    ),
                    DryingCondition(
                        plantCondition: "Recovery from week 2 onward",
                        dryingDuration: "3–4 hours/day",
                        dryingBestTime: "Morning to late morning",
                        dryingNote: "Gradually increase exposure duration"
                    )
                ],
                dryingTips: ""
            )
        ],
        colorHex: "01FED0"),
    Disease(
        diseaseId: "rust",
        nameDisease: "Rust",
        explanation: "A fungal disease caused by Phakopsora pachyrhizi (though rare in Aloe, rust-like symptoms can appear). It typically occurs in warm, moist conditions.",
        prevention: [
            Prevention(
                preventionTitle: "Identification of Early Symptoms",
                preventionDetail: "Orange, yellow, or reddish brown spots appear on the surface of the leaves, usually the underside. The leaves can look mottled and dry."
            ),
            Prevention(
                preventionTitle: "Prune Infected Leaves",
                preventionDetail: "Use sterile scissors to cut the affected leaves. Do not let it spread to other leaves."
            ),
            Prevention(
                preventionTitle: "Fix Air Circulation",
                preventionDetail: "Make sure the plants are not too tight, give a distance between the plants so that the air can flow smoothly and the humidity is reduced."
            ),
            Prevention(
                preventionTitle: "Reduce Excessive Moisture",
                preventionDetail: "Avoid watering the leaves. Focus on flushing the planting medium only, and only when really dry."
            ),
            Prevention(
                preventionTitle: "Natural Anti-Fungal Spray",
                preventionDetail: "Use baking soda solution (1 teaspoon per 1 liter of water + a little liquid soap) or neem oil regularly to prevent mold from returning."
            )
        ],
        watering: [
            Watering(
                wateringCondition: [
                    WateringCondition(
                        condition: "When Rust appears",
                        wateringFrequency: "Once every 10 days",
                        wateringVolume: "Just enough to moisten",
                        wateringNote: "Do not water the leaves, only the planting media"
                    ),
                    WateringCondition(
                        condition: "Recovery period (2–3 weeks)",
                        wateringFrequency: "Once every 7–10 days",
                        wateringVolume: "A bit around the root area",
                        wateringNote: "Ensure leaves stay dry, especially at night"
                    ),
                    WateringCondition(
                        condition: "After recovery",
                        wateringFrequency: "Once every 7–10 days",
                        wateringVolume: "Water thoroughly then drain",
                        wateringNote: "Continue monitoring for new rust symptoms"
                    )
                ],
                wateringTips: "✅ Tips: Use pots with good air circulation and fast-drying planting media."
            )
        ],
        drying: [
            Drying(
                dryingCondition: [
                    DryingCondition(
                        plantCondition: "Affected by rust",
                        dryingDuration: "2–4 hours/day",
                        dryingBestTime: "Morning (07:00–10:00)",
                        dryingNote: "Regular sun exposure helps reduce moisture"
                    ),
                    DryingCondition(
                        plantCondition: "In recovery",
                        dryingDuration: "3–6 hours/day",
                        dryingBestTime: "Morning to late morning",
                        dryingNote: "Avoid night dew and use shaded areas if too hot"
                    ),
                    DryingCondition(
                        plantCondition: "Indoor (prone to moisture)",
                        dryingDuration: "Place near window or take out every morning",
                        dryingBestTime: "Every day",
                        dryingNote: "Morning natural light helps prevent fungus and rust"
                    )
                ],
                dryingTips: ""
            )
        ],
        colorHex: "FF7E00"
    )
]
