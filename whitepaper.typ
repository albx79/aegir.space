// ============================================================
//  WHITEPAPER DRAFT — AEGIR LAUNCH SYSTEM
//  A Three-Stage Air-Breathing Launch Architecture for LEO
//
//  STATUS: Early draft. All [TODO] and [FILL] markers must be
//  resolved before submission. See inline notes for guidance.
//
//  Target venue: AIAA Space conference proceedings, or
//  Acta Astronautica (conceptual design level)
// ============================================================

// ---------- Document setup ----------
#set document(
  title: "Aegir: A Three-Stage Air-Breathing Launch System for Low-Cost LEO Access",
  author: "Alberto Colombo <albx79@gmail.com>",
)

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 3cm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 9pt, fill: luma(120))
      #smallcaps[Aegir Launch System — Conceptual Design] #h(1fr) Draft — #datetime.today().display()
    ]
  }
)

#set text(font: "New Computer Modern", size: 11pt, lang: "en")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#show table: set par(justify: false)

// ---------- Callout box for TODOs ----------
#let todo(body) = block(
  fill: rgb("#fff3cd"),
  stroke: rgb("#ffc107"),
  inset: 8pt,
  radius: 3pt,
  width: 100%,
)[#text(weight: "bold", fill: rgb("#856404"))[TODO: ]#body]

#let fill-me(body) = block(
  fill: rgb("#d1ecf1"),
  stroke: rgb("#0c5460"),
  inset: 8pt,
  radius: 3pt,
  width: 100%,
)[#text(weight: "bold", fill: rgb("#0c5460"))[FILL: ]#body]

#let note(body) = block(
  fill: rgb("#e8f4f8"),
  stroke: rgb("#6c757d"),
  inset: 8pt,
  radius: 3pt,
  width: 100%,
)[#text(weight: "bold", fill: rgb("#495057"))[Note: ]#text(style: "italic")[#body]]

// ---------- Inline placeholder for a citation not yet in references.yaml ----------
// Replace each #cite-me[...] with a real @key once the entry exists.
#let cite-me(body) = text(fill: rgb("#b02a37"), size: 0.9em)[\[cite: #body\]]


// ============================================================
//  TITLE PAGE
// ============================================================

#align(center)[
  #v(2cm)

  #text(size: 22pt, weight: "bold")[
    Aegir: A Three-Stage Air-Breathing \
    Launch System for Low-Cost LEO Access
  ]

  #v(0.8cm)

  #text(size: 13pt)[
    [FILL: Author name(s)] \
    [FILL: Affiliation(s)] \
    [FILL: Contact email]
  ]

  #v(0.5cm)
  #text(size: 10pt, fill: luma(100))[
    Draft — #datetime.today().display() \
    _Not for distribution_
  ]

  #v(1.5cm)
]

// ---------- Abstract ----------
// Unnumbered, so that the Introduction is Section 1.
#heading(numbering: none)[Abstract] <abstract>

#fill-me[Write abstract last, once all sections are stable. Target: 200--250 words. Should cover: motivation (cost reduction, flexibility), three-stage architecture summary, key novel elements (air-breathing stages, waverider Stage 2, tow-cable recovery), Fermi-level payload estimate (\~2 t to LEO), and identified open questions. Do not include numbers you are not confident in.]

#v(0.5cm)
*Keywords:* air-launch, ramjet, waverider, hypersonic, LEO access, reusable launch vehicle

#pagebreak()

// ============================================================
//  1. INTRODUCTION
// ============================================================

= Introduction <intro>

Access to low Earth orbit (LEO) remains constrained by the high per-kilogram cost of conventional vertical-launch rocket systems. While recent developments in rocket reusability --- most notably the Falcon 9 first-stage recovery --- have reduced costs substantially, the dominant cost drivers remain vehicle development, structural mass, and refurbishment, rather than propellant expenditure @falcon9-cost.

This paper presents *Aegir*, a conceptual three-stage launch architecture in which the first two stages are air-breathing and only the third stage uses a conventional rocket engine. The central thesis is that:

+ Air-breathing propulsion (turbofan for Stage 1, ramjet for Stage 2) offers specific impulse advantages over rocket propulsion across the Mach 0--5 regime, reducing the propellant mass burden on the orbital insertion stage.
+ Horizontal takeoff from existing commercial airports eliminates fixed launch infrastructure costs and provides operational flexibility in launch azimuth and staging latitude.
+ Aggressive reuse of Stages 1 and 2 --- with Stage 2 recovery via a novel tow-cable rendezvous mechanism --- keeps recurring costs low without requiring the full complexity of a single-stage-to-orbit vehicle.

The architecture specifically avoids the *spaceplane problem* --- designing a single vehicle that operates efficiently across the full Mach 0--25 range --- by treating the hypersonic regime (Mach 2.5--5) as a distinct, bounded design problem for Stage 2 alone.

#todo[Revisit thesis point 1. The baseline payload fraction (\~2% of the 100 t carried mass) is about the same as the all-solid Pegasus XL: the air-breathing Isp advantage is largely absorbed by the 45% Stage 2 hardware fraction. As the numbers stand, the paper's strongest arguments are reuse (point 3) and airport operations (point 2), not Isp. Either reframe point 1 or show where the Isp advantage reappears (e.g. if the ramjet propellant fraction turns out lower than 30% --- see @stage2).]

Each element of the architecture has precedent. Air-launch from a large subsonic carrier is an established technique: Pegasus has flown since 1990, first from a B-52 and later from the L-1011 _Stargazer_ #cite-me[Pegasus User's Guide]; Virgin Orbit's LauncherOne was carried under the wing of a modified 747-400 and reached orbit several times before the company ceased operations in 2023 #cite-me[LauncherOne system description]; and Stratolaunch's _Roc_, the largest aircraft by wingspan, now carries and releases the reusable Talon-A hypersonic test vehicle #cite-me[Stratolaunch Talon-A flight reports]. None of these, however, has carried more than about a quarter of the \~100 t external load assumed here (Pegasus XL weighs \~23 t), so the carry mass itself is an extrapolation.

Air-breathing propulsion at supersonic and low-hypersonic speed is likewise flight-proven, though not at Aegir's scale. Ramjet-powered vehicles include the Lockheed X-7 test vehicles, which reached about Mach 4.3 in the 1950s #cite-me[X-7 programme report]; the operational Bomarc surface-to-air missile #cite-me[Bomarc]; and the MBDA Meteor ducted-rocket missile #cite-me[Meteor]. The closest operational analogue to Stage 2 is the Lockheed D-21B reconnaissance drone, which was released from a B-52, accelerated by a solid rocket booster to ramjet takeover speed, and then cruised at above Mach 3 --- the same release--boost--ramjet sequence proposed here #cite-me[D-21 programme history]. The SR-71 provides the reference for sustained Mach 3+ cruise and its thermal environment #cite-me[SR-71 flight manual or NASA SR-71 reports]. The X-43A and X-51A demonstrated airframe-integrated air-breathing propulsion at Mach \~9.6 and \~5.1 respectively #cite-me[X-43A flight results; X-51A programme reports]; they are scramjets rather than ramjets, but are relevant for inlet--airframe integration and waverider-derived shaping. Notably, no flown ramjet has sustained Mach 5: Aegir's Stage 2 operating point lies at the upper edge of demonstrated ramjet experience.

The remainder of the paper is organised as follows. @architecture outlines the mission architecture and phase timeline. @stage1, @stage2 and @stage3 describe the three stages, and @separation-s12 and @separation-s23 treat the two staging events. @mass-budget presents the mass budget and its sensitivities, @prior-art compares Aegir with existing air-launch and air-breathing systems, and @risks lists the principal open questions. @conclusions summarises the findings.


// ============================================================
//  2. MISSION ARCHITECTURE OVERVIEW
// ============================================================

= Mission Architecture Overview <architecture>

The Aegir system comprises three stages, summarised in @tab-stage-summary. Stage 1 and Stage 2 are both reusable air-breathing vehicles; only Stage 2's solid booster is expended. Stage 3 is an expendable rocket upper stage.

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr, auto),
    inset: 6pt,
    align: (left, left, left, center, center),
    stroke: 0.5pt,
    table.header(
      [*Stage*], [*Vehicle*], [*Propulsion*], [*Reuse*], [*Separation condition*]
    ),
    [1], [Modified Airbus A380F], [4× turbofan], [Full reuse], [Mach 0.85, \~10,700 m],
    [2], [Hypersonic ramjet carrier], [Solid booster + ramjet], [Airframe reused (tow recovery); booster expended], [Mach 5.0, \~20,000 m],
    [3], [Rocket upper stage], [LOX/LH2 (or solid option)], [Expendable], [Orbital insertion],
  ),
  caption: [Stage summary for the Aegir launch system.],
) <tab-stage-summary>

The mission sequence is as follows. Stage 2 is mounted externally to Stage 1 and carried to the optimal separation point. Following release, a small solid booster accelerates Stage 2 through the transonic regime to ramjet ignition speed (\~Mach 2.5), after which the ramjet accelerates the combined Stage 2/3 stack to Mach 5 at approximately 20 km altitude. Stage 3 then separates and performs the orbital insertion burn. Stage 2 subsequently glides back to subsonic speed, rendezvouses with the returning Stage 1 aircraft via a tow-cable mechanism, and is recovered to a destination airport.

#fill-me[Insert a mission timeline figure here. A schematic showing the sequence of events (carry, release, boost, ramjet, separation, orbital insertion, glide-back, tow rendezvous) with approximate Mach number and altitude annotations on each phase. This is the single most important figure in the paper.]

The full mission phase timeline, with estimated durations and physical conditions at each phase transition, is presented in @tab-timeline.

#figure(
  table(
    columns: (auto, 1fr, auto, auto),
    inset: 5pt,
    align: (center, left, center, center),
    stroke: 0.5pt,
    table.header(
      [*Phase*], [*Description*], [*Condition*], [*Confidence*]
    ),
    [1],  [A380 takeoff, climb, cruise to release point], [Mach 0.85, 10,700 m], [High],
    [2],  [Arm-guided release of Stage 2 (inverted carry to clearance)], [Mach 0.85], [Low],
    [3],  [Stage 2 attitude flip (180° roll to flight orientation)], [Mach \~0.85, decelerating], [Low],
    [4],  [Solid booster ignition (may overlap with flip)], [Transonic], [Medium],
    [5],  [Ramjet ignition (after flip confirmed, inlet aligned)], [Mach \~2.5], [Medium],
    [6],  [Ramjet-powered acceleration and climb], [Mach 2.5 → 5, to 20 km], [Low],
    [7],  [Ramjet cutoff, Stage 2/3 separation], [Mach 5, 20 km], [Medium],
    [8],  [Coast gap (plume clearance) before Stage 3 ignition], [Diverging], [Low],
    [9],  [Stage 3 burn to LEO], [Mach 5 → orbital], [High],
    [10], [Stage 2 hypersonic glide-back to subsonic], [Mach 5 → 0.85], [Low],
    [11], [Stage 2 rendezvous with A380 tow cable], [Subsonic cruise], [Low],
    [12], [Stage 2 towed to destination airport], [Subsonic cruise], [Medium],
    [13], [Stage 2 release and independent landing], [Subsonic, descending], [Medium],
    [14], [Stage 3 and payload: deorbit and reentry], [Orbital → reentry], [N/A],
  ),
  caption: [Mission phase timeline. Confidence levels reflect the current state of analysis: High = grounded in standard aerospace analysis; Medium = plausible estimate requiring validation; Low = placeholder pending CFD, structural, or detailed trajectory analysis.],
) <tab-timeline>


// ============================================================
//  3. STAGE 1 — A380 CARRIER AIRCRAFT
// ============================================================

= Stage 1 --- Carrier Aircraft <stage1>

== Vehicle Selection

The Airbus A380F (freighter variant) is proposed as the Stage 1 carrier. The A380F offers a maximum takeoff weight of approximately 590,000 kg and a payload capacity of up to 158,000 kg in its freighter configuration @A380-spec. Its four-engine configuration, range (\~10,400 km as offered for the freighter, against \~15,000 km for the passenger A380), and wide availability of compatible airport infrastructure make it well-suited to the Stage 1 role.

#todo[Confirm the A380F range figure against the Airbus specification (@A380-spec). Range with a 100 t external store will be substantially lower still, because of the added drag; this sets the radius available for the tow-back leg in @stage2.]

#note[The A380F was formally offered by Airbus but never entered production. The passenger variant A380 has been produced in quantity; conversion to a freighter-compatible structural standard for external payload mounting would require significant modification regardless. This is not necessarily a barrier: the 747 Shuttle Carrier Aircraft (SCA) established precedent for major structural modification of a commercial widebody for external payload carry @SCA.]

== External Mount Configuration

Stage 2 is mounted externally beneath the wing root, in the spanwise gap between the A380 fuselage and the inboard engine nacelle on one side of the aircraft. This gap is estimated at approximately 9.5 m (centre fuselage to inner nacelle edge), providing adequate clearance for an 8.5 m wide Stage 2 vehicle with a \~0.5 m safety margin on each side.

#todo[Verify the fuselage-to-inboard-engine gap dimension from an official A380 3-view drawing or maintenance manual. The 9.5 m figure is derived from estimates of inboard engine position at \~57% of the outer engine span station and a fuselage radius of \~3.57 m. This is the most important geometric number to verify in the Stage 1 section. Check at the same time: (a) the wing-mounted main landing gear, whose track (\~14 m) appears to place it inside this gap; (b) vertical clearance between the wing-root underside and the ground for a 3.7 m tall vehicle during taxi and rotation.]

Stage 2 is carried *inverted* (inlet surface facing upward) during the carry phase, allowing the vehicle's bulkiest structural feature --- the ramjet inlet cowl --- to point away from the ground, thereby maximising ground clearance during taxi and rotation. The smooth leeward surface of the waverider faces down, presenting a lower-profile geometry in the most clearance-constrained direction.

Attachment is via multiple hardpoints distributed along the fuselage side and a primary wing-root structural attachment, distributing the \~100,000 kg load across several reaction points and reducing peak bending moment at any single location. The load is asymmetric (Stage 2 on one side only); fuel burn sequencing and continuous control trim compensate for the resulting rolling and yawing moment throughout the climb phase.

#todo[Develop at least a qualitative structural argument for the 100,000 kg external mount assumption. Minimum acceptable treatment: load path description, comparison to 747 SCA precedent (\~75,000 kg external dry payload with major structural work), and explicit acknowledgement that FEA validation is required. This number is the single most important assumption in the mass budget.]

== Release Mechanism

Stage 2 is released via a set of multi-jointed folding arms mounted to the fuselage and wing root. The arms actively guide Stage 2 laterally clear of the engine nacelle during the initial release phase, over a clearance distance estimated at approximately 15 m. This active guidance replaces the passive rail systems used in some prior air-launch designs, providing commanded control over Stage 2's trajectory during the most critical phase of the release sequence and reducing recontact risk.

#todo[Size the arm mechanism: number of joints, approximate actuator forces (must react Stage 2 drag and weight during the guided phase), deployment/retraction stowage geometry. This is currently hand-waved. Also justify why the arms walk Stage 2 sideways rather than lowering it straight down below the nacelle line.]

After physical clearance of the nacelle and fuselage, the arms release Stage 2 fully, and aerodynamic and propulsive control of Stage 2 begins.


// ============================================================
//  4. STAGE 2 — HYPERSONIC RAMJET CARRIER
// ============================================================

= Stage 2 --- Hypersonic Ramjet Carrier <stage2>

== Vehicle Shape and Sizing

Stage 2 is a waverider-class lifting body optimised for efficient hypersonic cruise in the Mach 2.5--5 regime. The waverider shape family generates lift by riding the compression shock it generates, achieving lift-to-drag ratios significantly higher than conventional blunt-body configurations at hypersonic speeds @waverider-LD.

The vehicle's outer dimensions are constrained by the 9.5 m carry gap (@stage1). A width of 8.5 m is adopted, with proportions derived from scaled X-43A geometry (length:width:height ratio approximately 5.5:2.3:1), yielding an estimated vehicle size of approximately:

- Length: \~20 m
- Width: \~8.5 m (constrained by carry gap)
- Height: \~3.7 m

Total enclosed volume is approximately 200--250 m³ at these proportions, sufficient to accommodate Stage 3, payload, ramjet propellant tankage, and structural members.

#note[The waverider proportions derived here are scaled from X-43A (length 3.66 m, width 1.53 m, height 0.66 m). X-43A is a small demonstrator; a linear scale factor of \~5.5 implies roughly 170× its volume, which introduces significant structural and aerothermal challenges not captured by geometric scaling alone. A dedicated aerodynamic and structural scaling study is required before these proportions should be treated as more than illustrative.]

#todo[Find published L/D data for waverider vehicles in the Mach 4--6 range. This is the most important missing technical anchor in the Stage 2 section, and the primary thing a reviewer will ask for. Candidate sources: NASA TM reports on waverider aerodynamics, X-43A flight data, HTV-2 publications.]

== Propulsion: Booster Phase

A solid-propellant rocket booster bridges the gap between Stage 1 separation speed (Mach 0.85) and the ramjet minimum useful operating speed (\~Mach 2.5). The ramjet cannot produce meaningful thrust below approximately Mach 2--2.5 due to insufficient inlet compression for stable subsonic combustion @ramjet-ignition.

The booster delta-v requirement is approximately 600 m/s, comprising \~490 m/s kinematic increment and \~110 m/s drag loss during transonic acceleration. Using HTPB composite solid propellant (Isp \~270 s), the Tsiolkovsky equation yields a booster propellant mass of \~20,300 kg and total booster mass of \~21,900 kg for a 100,000 kg total stack. The booster is jettisoned at Mach 2.5, reducing the stack mass for the ramjet phase to \~78,100 kg.

A solid booster is preferred over liquid alternatives (LOX/RP-1, LOX/LH2) for this application despite the lower specific impulse, for three reasons: (1) instant, reliable ignition in a time-critical separation sequence; (2) no cryogenic propellant handling for the booster at the launch airport (the baseline LOX/LH2 Stage 3 does still require cryogenic loading; the solid Stage 3 option in @stage3 would remove that requirement entirely); (3) negligible booster-size variation with propellant choice (\~2% spread in total booster mass across the Isp 250--285 s range), making the Isp disadvantage non-decisive at this delta-v.

*Dive-assisted acceleration.* An alternative to the booster is to trade altitude for speed by diving Stage 2 after release. This cannot replace the booster: accelerating from Mach 0.85 to Mach 2.5 at release altitude (from \~250 m/s to \~740 m/s) requires a specific-energy increase of \~240 kJ/kg, equivalent to \~25 km of altitude even with zero drag --- more than twice the 10.7 km release altitude. A partial dive does reduce the booster's delta-v, but the altitude given up must be regained by the ramjet on the climb to 20 km, and the transonic acceleration then takes place in denser air with higher drag losses. To first order the trade is neutral to slightly negative, so the booster is sized for acceleration from the release altitude without a dive.

== Propulsion: Ramjet Phase

Following booster jettison at Mach 2.5, the ramjet accelerates the vehicle from Mach 2.5 to the Stage 3 separation speed of Mach 5.0 at approximately 20 km altitude. Mach 5.0 is selected as a target at the upper edge of the ramjet operating envelope; sources place the practical ramjet ceiling at approximately Mach 5--6, above which inlet temperature rise begins to preclude stable subsonic combustion @ramjet-ceiling. Flown ramjets have so far reached about Mach 3--4.3 (see @intro).

#todo[Insert ramjet performance data: thrust as a function of Mach number and altitude, specific fuel consumption, operating envelope. This determines ramjet propellant mass and burn duration, both currently estimated at \~30% of the post-jettison vehicle mass and \~1--3 minutes respectively. These are the least well-grounded quantitative claims in the paper. Note that 30% may be generous: with a ramjet Isp of order 1,000 s or more, the Mach 2.5 → 5 acceleration plus climb may need closer to 10--15%, which would free payload margin.]

The separation conditions at the end of the ramjet phase are:

- Mach 5.0
- Altitude: \~20,000 m
- Dynamic pressure: \~95 kPa
- Stagnation temperature: \~1,000°C

The high dynamic pressure and stagnation temperature at separation are a materially harsher environment than the Stage 1/2 separation, and are discussed further in @separation-s23.

== Thermal Protection

The stagnation temperature at Mach 5 (\~1,000°C) requires thermal protection on the vehicle's leading edges and windward surfaces throughout the powered ascent phase and, more critically, during the unpowered glide-back to subsonic speed. This environment is substantially more severe than sustained supersonic cruise: convective heat flux scales roughly with $sqrt(rho) v^3$, so Mach 5 at 20 km gives about five times the heat flux of the SR-71 at Mach 3.2 and \~24 km (whose skin reached up to \~316°C). It remains well below orbital reentry conditions (Shuttle reentry at Mach \~25, peak heating \~1,650°C).

#todo[Identify candidate TPS materials: high-temperature alloys (Inconel, C-C composites) for leading edges, ceramic tiles or TUFROC-class materials for windward surfaces. Quantify TPS mass as a fraction of vehicle dry mass; this feeds directly into the hardware mass fraction assumption in the mass budget.]

== Recovery: Tow-Cable Rendezvous

Following Stage 3 separation at Mach 5, Stage 2 executes an unpowered hypersonic glide, decelerating from Mach 5 to subsonic cruise speed. The total specific energy at separation (kinetic + potential) is equivalent to a free-fall from approximately 131 km altitude, yielding a theoretical glide range of 200--600 km depending on hypersonic lift-to-drag ratio (estimated L/D range 2.5--4.5).

Rather than relying solely on this glide range to return Stage 2 to a launch-site-adjacent runway --- which would impose severe geographic constraints on the separation point --- Stage 2 instead rendezvouses with the returning Stage 1 A380, which deploys a tow cable. Stage 2 clamps onto the cable mid-span (approximately 70--80% of cable length from the aircraft, to avoid the high-oscillation free end) and is towed to any destination airport within the A380's remaining range.

Key elements of the tow-cable system:

- *Powered cable reel* mounted in the A380 tail section, adapted from military target-tow aircraft technology (existing systems rated to several km cable length)
- *Active drogue* at the cable free end: a drag-stabilised, sensor-equipped device that damps cable oscillations and provides GPS/relative-position telemetry to Stage 2's guidance system
- *Self-securing clamp* on Stage 2: a cam or scissor mechanism that locks tighter under tow load (analogous to a mountaineering rope grab), with pyrotechnic or electromechanical release for the final approach
- Estimated tow tension \~50,000--70,000 N (Stage 2 aerodynamic drag at A380 cruise speed, assuming dry Stage 2 mass \~35,000 kg, consistent with @tab-mass-budget, and subsonic L/D \~5--7)

This architecture eliminates the geographic coupling between separation point and recovery airport that would otherwise constrain operational flexibility --- one of the primary design goals of the system.

#todo[Characterise the cable dynamics quantitatively: oscillation amplitude at the mid-cable clamp point as a function of cable length, airspeed, and turbulence level. This is the key parameter that determines whether the mid-cable rendezvous is practically achievable. Likely needs a simple cable dynamics model or reference to tethered-body literature.]

=== Missed Capture and Retry Procedure

A missed capture does not end the recovery. Stage 2 is unpowered, but as a glider it keeps full control of speed, attitude and heading, and the A380 is free to manoeuvre and change altitude. After a miss, the two vehicles repeat the approach using the point-parallel geometry of in-flight refuelling #cite-me[NATO ATP-3.3.4.2 air-to-air refuelling procedures]. The A380 makes a 180° turn ahead of Stage 2 and rolls out in front of it on a common track, and Stage 2 makes its own 180° turn to fall in behind the cable. If the miss leaves Stage 2 only slightly behind and below the cable, no turn is needed: the A380 simply descends to re-present the cable, and that retry is much cheaper.

Because Stage 2 cannot regain altitude, the number of attempts is finite and set by its energy budget. At a subsonic L/D of \~6 and \~150 m/s, Stage 2 sinks at \~25 m/s in straight flight, and somewhat faster while banked. The altitude cost of a retry is therefore governed by the cycle time --- how long the A380 needs to turn and re-present the cable --- rather than by the angle Stage 2 turns through. A full 180°/180° cycle, including re-closing on the cable, takes an estimated 1.5--2 min and costs \~2.5--3.5 km of altitude; a descent-only retry costs of order 1 km. Starting the first attempt near the A380's practical towing altitude (\~12--13 km) and setting a floor of \~4 km gives two to three full retries. Arriving at the rendezvous higher than this buys holding time rather than additional attempts, since every attempt takes place at cable altitude. The retry budget can be increased by shortening the cycle: a shorter cable, tighter A380 turns at lower altitude, and above all a higher subsonic L/D.

Each retry also costs the A380 fuel, both directly (well under 0.5 t per cycle) and because the subsequent tow begins at a lower, less fuel-efficient altitude. The mission plan therefore includes a bingo-fuel rule: a maximum number of attempts, or a minimum altitude, after which recovery to the planned destination is abandoned. Diversion of the towed pair to a second- or third-choice airport is an acceptable outcome of a multi-attempt recovery.

If the final attempt fails, Stage 2 must glide to a runway on its own. From the \~4 km floor its glide range is only \~25 km (L/D × altitude), so the rendezvous area should be planned within reach of a suitable runway. This is a far weaker constraint than tying recovery to the launch site: any runway near the rendezvous area will do, which is straightforward over land but harder over open sea. Where no runway is reachable, the options are accepting loss of the vehicle, a recovery parachute, or a small cruise engine for diversion, at a mass cost.

#todo[Size the retry cycle properly: rendezvous geometry and timing for the point-parallel 180° turns, A380 turn performance with the cable deployed, Stage 2 subsonic drag polar and best-glide speed, and the resulting altitude cost per attempt. Derive the bingo rule (attempts, floor altitude, A380 fuel reserve) and the maximum distance from the rendezvous area to a fallback runway.]


// ============================================================
//  5. STAGE 1/2 SEPARATION
// ============================================================

= Stage 1/2 Separation <separation-s12>

The Stage 1/2 separation is the most mechanically complex event in the mission sequence. Unlike conventional air-launched vehicles (Pegasus, LauncherOne), which hang below the carrier and fall straight away from it on release, Stage 2 in the Aegir system sits beneath the wing root alongside the fuselage, boxed in by the fuselage on one side and the inboard engine nacelle on the other. It therefore requires active guidance to achieve safe clearance.

The inverted carry orientation (@stage1) ensures that the inlet cowl --- the vehicle's bulkiest protrusion --- faces upward into the wing/fuselage gap rather than downward toward the ground, maximising ground clearance while minimising the height of material protruding below the wing root during carry.

The release sequence is as follows:

+ The folding arms extend, walking Stage 2 laterally away from the fuselage over the engine nacelle clearance distance (\~15 m)
+ Once clear of nacelle interference, the arms release Stage 2
+ Stage 2 begins a \~180° roll to transition from inverted carry to flight orientation
+ The solid booster is ignited (this may overlap with the roll if the booster thrust axis is collinear with the roll axis, decoupling the two events)
+ Once the flip is complete and inlet alignment is confirmed, the ramjet is lit at approximately Mach 2.5

The \~180° roll represents the most novel element of this separation sequence. Since the booster thrust acts along the vehicle's longitudinal axis (the roll axis), powering the booster during the flip does not change the thrust direction and is therefore not inherently dangerous. The critical constraint is that the *ramjet* must not be ignited until the flip is complete and inlet flow is correctly established; booster ignition timing is more flexible.

#todo[Estimate the roll rate and roll duration achievable with the control surfaces available at Mach \~0.85--1.5 during the flip. This determines whether the flip completes before or after booster burnout, and hence whether the ramjet ignition timing is tight. A simple roll dynamics calculation using estimated vehicle moment of inertia and control surface authority would suffice at conceptual level.]

#todo[Address recontact risk quantitatively. The primary recontact scenario is Stage 2 being caught in the A380's wing wake and deflected back toward the fuselage. A CFD study of the combined-vehicle flow field is ultimately required, but a qualitative argument based on separation geometry and arm guidance authority should be included.]


// ============================================================
//  6. STAGE 2/3 SEPARATION
// ============================================================

= Stage 2/3 Separation <separation-s23>

Stage 2/3 separation occurs at Mach 5 and 20 km altitude, a substantially harsher aerodynamic and thermal environment than Stage 1/2 separation. The dynamic pressure at this condition is approximately 95 kPa --- roughly three times the maximum dynamic pressure of a typical ground-launched rocket ascent (\~30--35 kPa), and at the upper edge of the usual air-breathing flight corridor. The stagnation temperature of \~1,000°C means that any structural joint exposed during separation experiences a brief but intense thermal load.

#todo[Consider raising the separation altitude. At Mach 5, moving from 20 km to \~25--27 km roughly halves the dynamic pressure, easing both the separation mechanism and the Stage 3 start (see @stage3), at the cost of ramjet thrust in thinner air.]

The separation mechanism must:

- Provide positive stage-separation force against \~95 kPa dynamic pressure
- Cleanly expose and release Stage 3 without thermal damage to the separation joint or Stage 2's adjacent structure
- Ensure a sufficient coast gap (estimated 1--5 s) before Stage 3 ignition, to prevent rocket plume impingement on Stage 2's separation face

The sudden mass loss at separation (\~36% of Stage 2's pre-separation mass of \~54,700 kg, corresponding to Stage 3 plus payload at \~19,600 kg) induces a large, instantaneous shift in Stage 2's centre of gravity and moment of inertia. Stage 2's flight control system must handle this step change in trim, analogous to but larger in relative terms than the mass change experienced by a fighter aircraft releasing a large external store.

#todo[Survey existing stage separation mechanisms at similar dynamic pressures: Atlas/Centaur interstage separation, Pegasus stage separation. Identify which mechanisms are most applicable and what the scaling implications are for Aegir's size class.]


// ============================================================
//  7. STAGE 3 — ORBITAL INSERTION
// ============================================================

= Stage 3 --- Orbital Insertion <stage3>

Stage 3 is a conventional expendable rocket upper stage performing the orbital insertion burn from the Stage 2 separation condition (Mach 5, 20 km) to the target orbit. It is intentionally the least novel element of the system, relying entirely on established upper-stage rocket technology.

== Delta-V Budget

Starting from Mach 5 at 20 km altitude, the remaining delta-v to LEO is estimated as follows:

- Total delta-v to LEO from ground: \~9,500 m/s (including gravity and drag losses)
- Velocity credit from separation conditions (Mach 5 at 20 km): \~1,700 m/s
- Loss reduction credit (reduced gravity/drag losses from high-altitude, high-speed start): \~500 m/s
- *Remaining Stage 3 delta-v requirement: \~7,300 m/s*

#todo[Ground the loss-reduction credit of 500 m/s in published trajectory analyses or simulation. This is currently an estimate. Pegasus XL achieves approximately 300--400 m/s credit from its lower separation conditions; Aegir's higher Mach/altitude should justify more, but the exact value should be derived rather than assumed. This is one of the cleaner literature-search tasks in the paper.]

#todo[Check the Stage 3 start conditions, which may turn the loss credit into a penalty. A cryogenic stage with an RL-10-class engine has a thrust-to-weight ratio of only \~0.5--0.6; starting near-horizontal at 20 km and \~95 kPa, it must climb out of the dense atmosphere while still heavy, incurring gravity and drag losses that a vertical-launch upper stage never sees. A vacuum-optimised nozzle is also over-expanded at 20 km, so the 440--460 s Isp is not available early in the burn. Options: a higher-thrust engine, a pull-up by Stage 2 before separation, or a higher separation altitude (see @separation-s23).]

== Propellant and Mass Budget

Using LOX/LH2 propellant (Isp \~440 s, or up to \~460 s for an RL-10-class engine in vacuum), the Tsiolkovsky equation gives a mass ratio of approximately 5.4 for 7,300 m/s. Applied to the post-separation Stage 3 mass of \~19,600 kg, this yields:

- Stage 3 propellant: \~16,000 kg
- Stage 3 dry mass (structure, engine, tanks, avionics) at 10% of propellant: \~1,600 kg
- *Payload to LEO: \~2,000 kg*

#note[This figure should be treated as a Fermi estimate, not a design-grade performance prediction. The dominant uncertainties are the external mount limit (100,000 kg assumed), the Stage 2 hardware mass fraction (45% assumed), and the Stage 3 loss-reduction credit (500 m/s assumed). A parametric sensitivity analysis is presented in @mass-budget.]

== Modular Propellant Option

Stage 3 is intended to be modular in propellant choice. A solid-propellant upper stage (Isp \~290--300 s) would reduce specific impulse and hence payload capacity but may be preferred for certain missions (rapid response, simplicity, no cryogenic handling at the launch airport). The mass budget spreadsheet (see supplementary material) can be used to evaluate alternative propellant options.

#todo[Add a small table comparing payload-to-LEO for LOX/LH2 vs solid Stage 3 options, using the existing spreadsheet results.]


// ============================================================
//  8. MASS BUDGET
// ============================================================

= Mass Budget and Sensitivity Analysis <mass-budget>

== Baseline Estimate

The baseline mass budget is structured as follows, proceeding from the A380 external carry limit to the final payload:

#figure(
  table(
    columns: (1fr, auto, auto),
    inset: 6pt,
    align: (left, right, left),
    stroke: 0.5pt,
    table.header([*Parameter*], [*Value*], [*Notes*]),
    [A380 external carry limit], [100,000 kg], [Key uncertain assumption — see @stage1],
    [Solid booster propellant], [\~20,300 kg], [Tsiolkovsky, Isp = 270 s, Δv = 600 m/s],
    [Solid booster dry mass], [\~1,600 kg], [8% of propellant],
    [*Total booster (jettisoned)*], [*\~21,900 kg*], [Jettisoned at Mach 2.5],
    [Post-jettison stack mass], [\~78,100 kg], [Ramjet phase initial mass],
    [Stage 2 hardware (45%)], [\~35,100 kg], [Structure, TPS, engines, arms, clamp],
    [Stage 2 ramjet propellant (30%)], [\~23,400 kg], [Mach 2.5 → 5 acceleration],
    [*Stage 3 + payload at separation*], [*\~19,600 kg*], [25% of post-jettison mass; 36% of the stack at separation],
    [Stage 3 propellant], [\~16,000 kg], [LOX/LH2, Isp = 440 s],
    [Stage 3 dry mass], [\~1,600 kg], [10% of propellant],
    [*Payload to LEO*], [*\~2,000 kg*], [Baseline estimate],
  ),
  caption: [Baseline mass budget summary. All figures rounded to nearest 100 kg. See supplementary spreadsheet for full calculation with adjustable assumptions.],
) <tab-mass-budget>

== Sensitivity Analysis

The payload figure is most sensitive to the following parameters, in decreasing order of impact:

+ *A380 external carry limit* (currently 100,000 kg): a structural assessment allowing 120,000 kg would increase payload to approximately 2,400 kg.
+ *Stage 2 hardware mass fraction* (currently 45%): reducing to 40% (which requires TPS and structural mass targets to be met) recovers approximately 400--500 kg of payload.
+ *Stage 3 loss-reduction credit* (currently 500 m/s): grounding this in published trajectory analysis could revise payload by ±200--300 kg.
+ *Stage 3 Isp* (currently 440 s): using an RL-10C-class engine (Isp \~460 s) adds approximately 100--200 kg.

A combined optimistic scenario (120,000 kg carry limit, 40% hardware fraction, 550 m/s credit, 460 s Isp) yields approximately 3,000--3,200 kg to LEO.

#todo[Generate a proper sensitivity tornado chart from the spreadsheet. Show payload vs. each parameter varied ±10% with others held at baseline. This is straightforward to produce from the existing model. Include the ramjet propellant fraction (currently 30%) as a parameter.]


// ============================================================
//  9. COMPARISON WITH PRIOR ART
// ============================================================

= Comparison with Prior Art <prior-art>

#todo[Write this section. Key comparisons to include:

1. *Pegasus XL* (Northrop Grumman / Orbital Sciences): air-launched, three solid stages, \~450 kg to LEO from \~23,000 kg launch mass. Aegir carries \~4× the launch mass and targets \~4× the payload, at roughly similar payload fraction (\~2%). Key difference: Aegir uses air-breathing rather than all-rocket stages for the first two stages, potentially reducing propellant costs at the expense of Stage 2 development complexity.

2. *Virgin Orbit / LauncherOne*: air-launched liquid-propellant rocket, \~500 kg to LEO, 747-based carrier. Relevant as the closest operational precedent to Stage 1 underwing pylon mounting. Ceased operations 2023.

3. *Stratolaunch / Roc + Talon-A*: purpose-built twin-fuselage carrier, world's largest aircraft by wingspan. Relevant as a precedent for purpose-built air-launch carrier design and separation testing methodology.

4. *SABRE / Skylon (Reaction Engines)*: single-stage-to-orbit concept using a combined-cycle engine. Contrast with Aegir's deliberate avoidance of the single-stage-to-orbit problem; Aegir addresses only the Mach 0--5 air-breathing slice and leaves orbital insertion to a conventional rocket.

5. *Lockheed D-21B*: air-launched from a B-52, solid booster to ramjet takeover, then ramjet cruise above Mach 3. The closest flown analogue to the Stage 2 propulsion sequence.]


// ============================================================
//  10. IDENTIFIED RISKS AND OPEN QUESTIONS
// ============================================================

= Identified Risks and Open Questions <risks>

The following items represent the most significant open technical questions requiring resolution before the Aegir concept can advance beyond Fermi-level feasibility assessment. They are listed in approximate order of programme risk.

+ *Stage 2 aerodynamic performance*: No aerodynamic analysis of the Stage 2 waverider has been performed. Hypersonic L/D, drag polar, and inlet capture efficiency are required to validate the mass budget and glide-back range estimates. Priority: high. Method: CFD or wind-tunnel test at representative Mach numbers.

+ *A380 external carry limit*: The 100,000 kg external mount assumption has no structural analysis behind it. The 747 SCA precedent (\~75,000 kg) is the nearest data point. A load path analysis and preliminary finite-element study of an A380 fuselage/wing-root structure with external mount hardpoints is the required next step.

+ *Stage 1/2 separation flow field*: Recontact risk during the arm-guided release has not been quantified. A CFD study of the combined A380/Stage 2 configuration at separation conditions is needed to validate the arm guidance approach and size the required clearance distance.

+ *Ramjet performance data*: Thrust, specific fuel consumption, and operating envelope data for a ramjet in the Mach 2.5--5 regime at 10--20 km altitude are needed to validate Stage 2 propellant mass fractions. This information exists in the open literature (D-21, X-7 and Meteor programme literature, generic ramjet studies) and should be the subject of a focused literature review.

+ *Tow-cable dynamics*: The mid-cable rendezvous concept requires validation of cable oscillation amplitudes at the clamp point as a function of cable length, airspeed, and turbulence. A simple cable dynamics model or reference to existing tethered-body literature would provide the required grounding.

+ *Stage 2 TPS mass*: The 45% hardware mass fraction assumption folds in TPS mass without explicit sizing. A TPS mass estimate based on surface area, peak heat flux (\~1,000°C stagnation), and candidate materials (Inconel leading edges, ceramic tile windward surface) is needed to validate or revise this fraction.

+ *Stage 2/3 separation mechanism*: No separation mechanism has been specified for the Mach 5 / 20 km condition. Existing stage-separation heritage (Atlas/Centaur, Pegasus stages) should be surveyed for applicable mechanisms.


// ============================================================
//  11. CONCLUSIONS
// ============================================================

= Conclusions <conclusions>

#fill-me[Write after all other sections are stable. Should: (1) restate the core claim (Aegir offers a path to \~2 t LEO payload using air-breathing first two stages, launched from commercial airports, with reuse of Stage 1 and of the Stage 2 airframe via tow-cable recovery); (2) summarise the mass budget result and its key uncertainties; (3) identify the two or three most important next steps (aerodynamic study of Stage 2, structural assessment of A380 external mount, ramjet performance literature survey); (4) make a qualified claim about cost competitiveness relative to Pegasus/LauncherOne class systems.]


// ============================================================
//  REFERENCES
// ============================================================

#heading(numbering: none)[References] <references>

#todo[Populate with real references, and replace each red #cite-me[...] marker in the text with an \@key reference. Placeholder list of sources to find and cite:
- Airbus A380 Type Certificate Data Sheet (EASA) — for MTOW and structural data
- Ramjet operating envelope data (suggest starting with D-21, X-7 and Meteor programme literature; X-51 is a scramjet)
- X-43A vehicle description and flight data (NASA TM-2006-214392 or similar)
- X-51A programme reports (scramjet heritage, waverider-derived shaping)
- Lockheed D-21 / D-21B programme history
- SR-71 thermal environment (NASA flight research reports)
- Waverider L/D data: Küchemann 1978, or more recent Starkey & Lewis (2001)
- Pegasus User's Guide (Northrop Grumman) — for comparison data
- 747 Shuttle Carrier Aircraft modification documentation (NASA TM or JSC report)
- Virgin Orbit LauncherOne system description
- Stratolaunch Talon-A separation test report (if publicly available)
- Tsiolkovsky rocket equation — standard reference
- ISA atmosphere model (ISO 2533:1975)
]

// Placeholder bibliography block — replace with real .bib file
#bibliography("references.yaml", title: none)
